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
    private let locationManager: CLLocationManager = .init()
    private var startTime: Date? = nil
    private var timer: Timer? = nil
    private var baseSeconds: Int = 0
    
    
    // MARK: - Init
    init(courseId: Int) {
        self.courseId = courseId
        super.init()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
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
                let courseService = NetworkService<CourseAPI>()
                let response = try await courseService.request(
                    .getCourseDetail(courseId: courseId),
                    responseDTO: CourseDetailResponseDTO.self)
                await setCourseDetail(response.data)
                await setUncompletedRide(response.data.hasUncompletedRide)
            } catch {
                print(error)
                print("코스 디테일 조회 실패😭")
            }
        }
    }
    
    func requestStartRiding() {
        
    }
    
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
}

// MARK: - Timer
extension CourseDetailViewModel {
    func startTimer() {
        startTime = Date()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerPerSecond), userInfo: nil, repeats: true)
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    @objc func updateTimerPerSecond() {
        guard let startTime = startTime else { return }
        let timeElapsed = Int(Date().timeIntervalSince(startTime))
        spentSeconds = timeElapsed + baseSeconds
    }
    
    private func exitTimer() {
        timer?.invalidate()
        timer = nil
        print("EXIT TIMER")
    }
}
