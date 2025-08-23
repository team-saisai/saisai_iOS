//
//  CourseDetailViewModel.swift
//  SaiSai
//
//  Created by 이창현 on 7/20/25.
//

import Foundation
import CoreLocation

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
        exitTimer()
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
                let response = try await ridesService.request(.startRides(courseId: courseId), responseDTO: StartRidesResponseDTO.self)
                startTimer()
                await setRideId(response.data.rideId)
                print(response.data.rideId)
                await setIsRideCompleted(false)
                await setTotalDistance(response.data.distance)
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
    
    func requestResumeRiding() {
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
    
    func requestCompleteRiding() {
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
            } catch {
                print(error)
                print("라이딩 종료 실패")
            }
        }
    }
    
    func requestToggleIsPaused() {
        Task { [weak self] in
            guard let self = self else { return }
            isPaused ? requestResumeRiding() : requestPauseRiding()
        }
    }
}

extension CourseDetailViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        Task { [weak self] in
            guard let self = self else { return }
            guard let location = locations.last else { return }
            print("latitude: \(location.coordinate.latitude)")
            print("longitude: \(location.coordinate.longitude)")
            await setUserLocation(location.coordinate.latitude, location.coordinate.longitude)
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
            self?.isPaused = true
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
        print("Ride Id DEBUG: \(rideId)")
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
    }
}
