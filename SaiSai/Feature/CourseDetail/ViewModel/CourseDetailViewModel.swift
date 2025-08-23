//
//  CourseDetailViewModel.swift
//  SaiSai
//
//  Created by 이창현 on 7/20/25.
//

import Foundation
import CoreLocation
import Combine

final class CourseDetailViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    let courseId: Int
    @Published var courseDetail: CourseDetailInfo? = nil
    @Published var isSummaryViewFolded: Bool = true
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0
    @Published var spentSeconds: Int = 0
    @Published var rideId: Int? = nil
    @Published var totalDistance: Double = 0.0
    @Published var heading: CLLocationDirection? = nil
    @Published var checkpointList: [CheckPointInfo] = []
    @Published var lastCheckedPointIdx: Int = -1
    @Published var hasUncompletedRide: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isPaused: Bool = true
    @Published var isRidingCourseSummaryFolded: Bool = true
    @Published var isCancelAlertPresented: Bool = false
    
    let cancelAlertButtonTappedPublisher: PassthroughSubject<Bool, Never> = .init()
    
    let locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.startUpdatingHeading()
        return locationManager
    }()
    private var startTime: Date? = nil
    private weak var timer: Timer? = nil
    private var baseSeconds: Int = 0
    var numOfTotalCheckpoints: Int {
        checkpointList.count + 2
    }
    var numOfPassedCheckpoints: Int {
        lastCheckedPointIdx + 1
    }
    
    let courseService = NetworkService<CourseAPI>()
    let ridesService = NetworkService<RidesAPI>()
    
    
    // MARK: - Init
    init(courseId: Int) {
        self.courseId = courseId
        super.init()
        self.locationManager.delegate = self
//        self.locationManager.startUpdatingLocation()
    }
    
    // MARK: - Deinit
    deinit {
        print("DEINIT: CourseDetailViewModel")
    }
    
    // MARK: - Methods
    func fetchData() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let response = try await courseService.request(
                    .getCourseDetail(courseId: courseId),
                    responseDTO: CourseDetailResponseDTO.self)
                await setCourseDetail(response.data)
                await setCheckPointList(response.data.checkpoint)
                await setRideId(response.data.rideId)
                if let _ = response.data.rideId {
                    requestResumeRiding()
                }
            } catch {
                print(error)
                print("코스 디테일 조회 실패😭")
            }
        }
    }
    
    func requestStartRiding() {
        Task { [weak self] in
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
                    await sendDistanceToFarToast()
                }
            } catch {
                print(error)
                print("라이딩 시작 실패")
            }
        }
    }
    
    func requestPauseRiding() {
        Task { [weak self] in
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
            } catch {
                print(error)
                print("라이딩 중지 실패")
            }
        }
    }
    
    private func requestResumeRiding() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                guard let rideId = rideId else { return }
                print("RIDEID: \(rideId)")
                let response = try await ridesService.request(
                    .resumeRides(rideId: rideId),
                    responseDTO: ResumeRidesResponseDTO.self)
                baseSeconds = response.data.durationSecond
                await setLastCheckpointIdx(response.data.checkpointIdx)
                startTimer()
            } catch {
                print(error)
                print("라이딩 재개 실패")
            }
        }
    }
    
    private func requestCompleteRiding() {
        Task { [weak self] in
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
                await setIsRideCompleted(true)
                // complete modal on
            } catch {
                print(error)
                print("라이딩 종료 실패")
            }
        }
    }
    
    private func requestSyncCheckpoint() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                guard let rideId = rideId else { return }
                let _ = try await ridesService.request(
                    .syncRide(
                        rideId: rideId,
                        duration: spentSeconds,
                        checkpointIdx: lastCheckedPointIdx
                    ),
                    responseDTO: SyncRideResponseDTO.self
                )
                await setLastCheckpointIdx(lastCheckedPointIdx + 1)
            } catch {
                print(error)
                print("체크포인트 sync 실패")
            }
        }
    }
    
    func requestToggleIsPaused() {
        Task { [weak self] in
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
}

extension CourseDetailViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        Task { [weak self] in
            guard let self = self else { return }
            guard let userLocation = locations.last else { return }
            print("latitude: \(userLocation.coordinate.latitude)")
            print("longitude: \(userLocation.coordinate.longitude)")
            await setUserLocation(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
            if lastCheckedPointIdx < checkpointList.count && !checkpointList.isEmpty {
                let checkpointLocation = CLLocation(
                    latitude: checkpointList[lastCheckedPointIdx].latitude,
                    longitude: checkpointList[lastCheckedPointIdx].longitude
                )
                if isOnLocation(checkpointLocation, userLocation) {
                    requestSyncCheckpoint()
                }
            } else {
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async {
            self.heading = newHeading.trueHeading
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
        if rideId == nil {
            hasUncompletedRide = false
        }
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
        self.hasUncompletedRide = isRideCompleted
        self.isCompleted = true
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
    func sendDistanceToFarToast() {
        ToastManager.shared.toastPublisher.send(.distanceToFar)
    }
}
