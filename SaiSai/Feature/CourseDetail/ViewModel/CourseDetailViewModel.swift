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
    @Published var hasUncompletedRide: Bool = false
    @Published var isSummaryViewFolded: Bool = true
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0
    @Published var spentSeconds: Int = 0
    @Published var rideId: Int = 0
    @Published var totalDistance: Double = 0.0
    @Published var currentDistance: Double = 0.0
    @Published var heading: CLLocationDirection? = nil
    var progressPercentage: Double {
        if totalDistance <= 0 {
            return 0
        }
        return currentDistance / totalDistance
    }
    let locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.startUpdatingHeading()
        return locationManager
    }()
    private var startTime: Date? = nil
    private var timer: Timer? = nil
    private var baseSeconds: Int = 0
    
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
                await setUncompletedRide(response.data.hasUncompletedRide)
                if response.data.hasUncompletedRide {
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
                await setTotalDistance(totalDistance)
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
                let _ = try await ridesService.request(
                    .pauseRides(
                        rideId: rideId,
                        duration: spentSeconds,
                        totalDistance: currentDistance),
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
                let response = try await ridesService.request(
                    .resumeRides(rideId: rideId),
                    responseDTO: ResumeRidesResponseDTO.self)
                baseSeconds = response.data.durationSecond
                currentDistance = response.data.actualDistance // 아직 명세에 추가 안됨.
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
                let response = try await ridesService.request(
                    .completeRides(rideId: rideId,
                                   duration: spentSeconds,
                                   actualDistance: currentDistance),
                    responseDTO: ResumeRidesResponseDTO.self)
            } catch {
                print(error)
                print("라이딩 재개 실패")
            }
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
        startTime = Date()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerPerSecond), userInfo: nil, repeats: true)
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .default)
        }
    }
    
    @objc func updateTimerPerSecond() {
        guard let startTime = startTime else { return }
        let timeElapsed = Int(Date().timeIntervalSince(startTime))
        spentSeconds = timeElapsed + baseSeconds
        print(spentSeconds)
    }
    
    private func exitTimer() {
        timer?.invalidate()
        timer = nil
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
    func setUncompletedRide(_ hasUncompletedRide: Bool) {
        self.hasUncompletedRide = hasUncompletedRide
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
    func setRideId(_ rideId: Int) {
        self.rideId = rideId
    }
    
    @MainActor
    func setTotalDistance(_ totalDistance: Double) {
        self.totalDistance = totalDistance
    }
    
    @MainActor
    func setCurrentDistance(_ currentDistance: Double) {
        self.currentDistance = currentDistance
    }
}
