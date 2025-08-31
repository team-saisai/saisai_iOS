//
//  CourseDetailViewModel.swift
//  SaiSai
//
//  Created by 이창현 on 7/20/25.
//

import Foundation
import CoreLocation
import Combine
import Moya

final class CourseDetailViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    let courseId: Int
    let isByContinueButton: Bool
    @Published var courseDetail: CourseDetailInfo? = nil
    @Published var isSummaryViewFolded: Bool = true
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0
    @Published var spentSeconds: Int = 0
    @Published var rideId: Int? = nil
    @Published var totalDistance: Double = 0.0
    @Published var checkpointList: [CheckPointInfo] = []
    @Published var lastCheckedPointIdx: Int = -1
    @Published var hasUncompletedRide: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isPaused: Bool = true
    @Published var isRidingCourseSummaryFolded: Bool = true
    @Published var isCancelAlertPresented: Bool = false
    @Published var isInstructionAlertPresented: Bool = false
    @Published var isUserLocationAllowAlertPresented: Bool = false
    @Published var isToastPresented: Bool = false
    @Published var toastType: ToastType = .requestFailure
    let neverCheckedDate: String = "lastNeverChecked"
    
    var isAlertPresented: Bool {
        isCancelAlertPresented || isInstructionAlertPresented || isUserLocationAllowAlertPresented
    }
    
    let cancelAlertButtonTappedPublisher: PassthroughSubject<Bool, Never> = .init()
    let userLocationAlertButtonTappedPublisher: PassthroughSubject<Bool, Never> = .init()
    let startButtonOnInstructionPublisher: PassthroughSubject<Bool, Never> = .init()
    
    private var subscriptions: Set<AnyCancellable> = .init()
    
    let locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.startUpdatingHeading()
        return locationManager
    }()
    private var startTime: Date? = nil
    private weak var timer: Timer? = nil
    private var baseSeconds: Int = 0
    var numOfTotalCheckpoints: Int {
        checkpointList.count
    }
    var numOfPassedCheckpoints: Int {
        lastCheckedPointIdx + 1
    }
    var checkpointPercentage: Int {
        if (numOfPassedCheckpoints == numOfTotalCheckpoints) && !isCompleted {
            return 99
        }
        return Int((Double(numOfPassedCheckpoints) * 100.0 / Double(numOfTotalCheckpoints)).rounded())
    }
    
    let courseService = NetworkService<CourseAPI>()
    let ridesService = NetworkService<RidesAPI>()
    
    
    // MARK: - Init
    init(
        courseId: Int,
        isByContinueButton: Bool = false
    ) {
        self.courseId = courseId
        self.isByContinueButton = isByContinueButton
        super.init()
        self.locationManager.delegate = self
        self.bind()
//        self.locationManager.startUpdatingLocation()
    }
    
    // MARK: - Deinit
    deinit {
        print("DEINIT: CourseDetailViewModel")
    }
    
    // MARK: - Methods
    func fetchData() {
        _Concurrency.Task { [weak self] in
            guard let self = self else { return }
            do {
                let response = try await courseService.request(
                    .getCourseDetail(courseId: courseId),
                    responseDTO: CourseDetailResponseDTO.self)
                await setCourseDetail(response.data)
                await setCheckPointList(response.data.checkpoint)
                await setRideId(response.data.rideId)
                if let _ = response.data.rideId {
                    requestResumeRiding(isByContinueButton)
                }
            } catch let error as MoyaError {
                print(error)
                if error.response?.statusCode ?? 0 / 100 == 5 {
                    await sendToast(.requestFailure)
                }
                print("코스 디테일 조회 실패😭")
            }
        }
    }
    
    func requestStart() {
        _Concurrency.Task { [weak self] in
            guard let self = self else { return }
            if let lastNeverChecked = UserDefaults.standard.value(forKey: neverCheckedDate) {
                if lastNeverChecked as? String == Date().yearMonthDayDate {
                    requestStartRiding()
                } else {
                    await setIsInstructionAlertPresented(true)
                }
            } else {
                await setIsInstructionAlertPresented(true)
            }
        }
    }
    
    func requestStartRiding() {
        _Concurrency.Task { [weak self] in
            guard let self = self else { return }
            do {
                if isOnStartingPoint() {
                    let response = try await ridesService.request(.startRides(courseId: courseId), responseDTO: StartRidesResponseDTO.self)
                    startTimer()
                    await setRideId(response.data.rideId)
                    print(response.data.rideId)
                    await setIsRideCompleted(false)
                    await setTotalDistance(response.data.distance)
                } else {
                    await sendToast(.distanceToFar)
                }
            } catch let error as MoyaError {
                print(error)
                if error.response?.statusCode ?? 0 / 100 == 5 {
                    await sendToast(.requestFailure)
                }
                print("라이딩 시작 실패")
            }
        }
    }
    
    func requestPauseRiding() {
        _Concurrency.Task { [weak self] in
            guard let self = self else { return }
            do {
                guard let rideId = rideId else { return }
                let _ = try await ridesService.request(
                    .pauseRides(
                        rideId: rideId,
                        duration: spentSeconds,
                        checkpointIdx: lastCheckedPointIdx
                    ),
                    responseDTO: PauseRidesResponseDTO.self)
                exitTimer()
            } catch let error as MoyaError {
                print(error)
                if error.response?.statusCode ?? 0 / 100 == 5 {
                    await sendToast(.requestFailure)
                }
                if error.response?.statusCode == 409 {
                    await sendToast(.anotherRidingExists)
                }
                print("라이딩 중지 실패")
            }
        }
    }
    
    private func requestResumeRiding(_ isByContinueButton: Bool = true) {
        _Concurrency.Task { [weak self] in
            guard let self = self else { return }
            do {
                guard let rideId = rideId else { return }
                print("RIDEID: \(rideId)")
                let response = try await ridesService.request(
                    .resumeRides(rideId: rideId),
                    responseDTO: ResumeRidesResponseDTO.self)
                baseSeconds = response.data.durationSecond
                await setLastCheckpointIdx(response.data.checkpointIdx)
                if isByContinueButton {
                    startTimer()
                } else {
                    await setSpentSeconds(baseSeconds)
                }
            } catch let error as MoyaError {
                print(error)
                if error.response?.statusCode ?? 0 / 100 == 5 {
                    await sendToast(.requestFailure)
                }
                if error.response?.statusCode == 409 {
                    await sendToast(.anotherRidingExists)
                }
                print("라이딩 재개 실패")
            }
        }
    }
    
    private func requestCompleteRiding() {
        _Concurrency.Task { [weak self] in
            guard let self = self else { return }
            do {
                guard let rideId = rideId else { return }
                let _ = try await ridesService.request(
                    .completeRides(
                        rideId: rideId,
                        duration: spentSeconds
                    ),
                    responseDTO: CompleteRidesResponseDTO.self
                )
                exitTimer()
                await setIsRideCompleted(true)
            } catch let error as MoyaError {
                print(error)
                if error.response?.statusCode ?? 0 / 100 == 5 {
                    await sendToast(.requestFailure)
                }
                print("라이딩 종료 실패")
            }
        }
    }
    
    private func requestSyncCheckpoint() {
        _Concurrency.Task { [weak self] in
            guard let self = self else { return }
            do {
                guard let rideId = rideId else { return }
                let _ = try await ridesService.request(
                    .syncRide(
                        rideId: rideId,
                        duration: spentSeconds,
                        checkpointIdx: lastCheckedPointIdx + 1
                    ),
                    responseDTO: SyncRideResponseDTO.self
                )
                await setLastCheckpointIdx(lastCheckedPointIdx + 1)
            } catch let error as MoyaError {
                print(error)
                if error.response?.statusCode ?? 0 / 100 == 5 {
                    await sendToast(.requestFailure)
                }
                print("체크포인트 sync 실패")
            }
        }
    }
    
    func requestToggleIsPaused() {
        _Concurrency.Task { [weak self] in
            guard let self = self else { return }
            isPaused ? requestResumeRiding() : requestPauseRiding()
        }
    }
    
    private func isOnLocation(_ location1: CLLocation, _ location2: CLLocation) -> Bool {
        let distance = location1.distance(from: location2)
        return distance <= 50
    }
    
    private func isOnStartingPoint() -> Bool {
        let userLocation = CLLocation(
            latitude: userLatitude,
            longitude: userLongitude
        )
        if let locations = courseDetail?.locations, !locations.isEmpty {
            let startingPointLocation = CLLocation(
                latitude: locations[0].latitude,
                longitude: locations[1].longitude
            )
            return isOnLocation(startingPointLocation, userLocation)
        }
        return false
    }
    
    private func bind() {
        startButtonOnInstructionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                _Concurrency.Task { [weak self] in
                    guard let self = self else { return }
                    await setIsInstructionAlertPresented(false)
                    requestStartRiding()
                }
                switch $0 {
                case true:
                    UserDefaults.standard.set(Date().yearMonthDayDate, forKey: neverCheckedDate)
                case false:
                    break
                }
            }
            .store(in: &subscriptions)
    }
}

extension CourseDetailViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        _Concurrency.Task { [weak self] in
            guard let self = self else { return }
            guard let userLocation = locations.last else { return }
            print("latitude: \(userLocation.coordinate.latitude)")
            print("longitude: \(userLocation.coordinate.longitude)")
            await setUserLocation(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
            let nextCheckPointIdx = lastCheckedPointIdx + 1
            if (nextCheckPointIdx < checkpointList.count) && !checkpointList.isEmpty && !isPaused {
                let checkpointLocation = CLLocation(
                    latitude: checkpointList[nextCheckPointIdx].latitude,
                    longitude: checkpointList[nextCheckPointIdx].longitude
                )
                if isOnLocation(checkpointLocation, userLocation) {
                    requestSyncCheckpoint()
                }
            } else if nextCheckPointIdx == checkpointList.count && !isPaused {
                if let destination = courseDetail?.locations.last {
                    let destLocation = CLLocation(
                        latitude: destination.latitude,
                        longitude: destination.longitude
                    )
                    if isOnLocation(destLocation, userLocation) {
                        requestCompleteRiding()
                    }
                }
            }
        }
    }
}

// MARK: - Timer Methods
extension CourseDetailViewModel {
    func startTimer() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isPaused = false
            startTime = Date()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerPerSecond), userInfo: nil, repeats: true)
            if let timer = timer {
                RunLoop.main.add(timer, forMode: .common)
            }
        }
    }
    
    @objc func updateTimerPerSecond() {
        guard let startTime = startTime else { return }
        let timeElapsed = Int(Date().timeIntervalSince(startTime))
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            spentSeconds = timeElapsed + baseSeconds
        }
        print(spentSeconds)
    }
    
    func exitTimer() {
        timer?.invalidate()
        timer = nil
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isPaused = true
        }
        print("EXIT TIMER")
    }
}

// MARK: - Methods for Updating UI
extension CourseDetailViewModel {
    
    @MainActor
    private func setCourseDetail(_ courseDetail: CourseDetailInfo) {
        self.courseDetail = courseDetail
    }
    
    @MainActor
    func toggleSummaryFoldState() {
        self.isSummaryViewFolded.toggle()
    }
    
    @MainActor
    func setRideId(_ rideId: Int?) {
        self.rideId = rideId
        hasUncompletedRide = !(rideId == nil)
    }
    
    @MainActor
    func startUpdatingLocation()
    {
        self.locationManager.startUpdatingLocation()
    }
    
    @MainActor
    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }
    
    @MainActor
    func setUserLocation(_ userLatitude: Double, _ userLongitude: Double) {
        self.userLatitude = userLatitude
        self.userLongitude = userLongitude
    }
    
    @MainActor
    func setCheckPointList(_ checkpointList: [CheckPointInfo]) {
        self.checkpointList = checkpointList
    }
    
    @MainActor
    func setLastCheckpointIdx(_ checkpointIdx: Int) {
        self.lastCheckedPointIdx = checkpointIdx
    }
    
    @MainActor
    func setTotalDistance(_ totalDistance: Double) {
        self.totalDistance = totalDistance
    }
    
    @MainActor
    func setIsRideCompleted(_ isRideCompleted: Bool) {
        self.isCompleted = isRideCompleted
    }
    
    @MainActor
    func toggleIsRidingCourseSummaryFolded() {
        self.isRidingCourseSummaryFolded.toggle()
    }
    
    @MainActor
    func setIsCancelAlertPresented(_ isCancelAlertPresented: Bool) {
        self.isCancelAlertPresented = isCancelAlertPresented
    }
    
    @MainActor
    func setIsUserLocationAlertPresented(_ isUserLocationAlertPresented: Bool) {
        self.isUserLocationAllowAlertPresented = isUserLocationAlertPresented
    }
    
    @MainActor
    func setIsInstructionAlertPresented(_ isInstructionAlertPresented: Bool) {
        self.isInstructionAlertPresented = isInstructionAlertPresented
    }
    
    @MainActor
    private func sendToast(_ toastType: ToastType) {
        self.toastType = toastType
        if !isToastPresented {
            self.isToastPresented = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isToastPresented = false
            }
        }
    }
    
    @MainActor
    func setIsToastPresented(_ isToastPresented: Bool) {
        self.isToastPresented = isToastPresented
    }
    
    @MainActor
    func isUserLocationAvailable() {
        let locationManager = LocationPermissionManager()
        let isAvailable =  locationManager.manager.authorizationStatus == .authorizedWhenInUse || locationManager.manager.authorizationStatus == .authorizedAlways
        self.isUserLocationAllowAlertPresented = !isAvailable
    }
    
    @MainActor
    func setSpentSeconds(_ seconds: Int) {
        self.spentSeconds = seconds
    }
    
    @MainActor
    func removeAlert() {
        if isCancelAlertPresented {
            isCancelAlertPresented = false
        }
        if isInstructionAlertPresented {
            isInstructionAlertPresented = false
        }
    }
}
