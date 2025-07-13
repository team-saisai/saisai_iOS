//
//  HomeViewModel.swift
//  SaiSai
//
//  Created by 이창현 on 7/8/25.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published var name: String = "델라"
    @Published var isRecentRideExists: Bool = false
    @Published var recentRide: RecentRideInfo = RecentRideInfo(courseId: 0, courseName: "", sigun: "", courseImageUrl: nil, distance: 0.0, progressRate: 0, recentRideAt: "")
    @Published var popularCourses: [CourseInfo] = []
    
    func fetchData() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let courseService = NetworkService<CourseAPI>()
                
                // TODO: - 이름 추가 필요
                
                let recentResponse = try await courseService.request(.getRecentMyRides, responseDTO: MyRecentRidesResponseDTO.self)
                let recent = recentResponse.data
                await setRecentRides(recent)
                
                let popularResponse = try await courseService.request(.getPopularCourses, responseDTO: PopularCourseResponseDTO.self)
                let populars = popularResponse.data
                await setPopularCourses(populars)
                
            } catch {
                print("홈 정보 제공 실패 😭")
            }
        }
    }
}

// MARK: - Methods for Published Var
extension HomeViewModel {
    @MainActor
    private func setName(_ name: String) {
        self.name = name
    }
    
    @MainActor
    private func setRecentRides(_ recentRide: RecentRideInfo) {
        self.recentRide = recentRide
    }
    
    @MainActor
    private func setPopularCourses(_ popularCourses: [CourseInfo]) {
        self.popularCourses = popularCourses
    }
}
