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
    @Published var isRecentRideDone: Bool = false
    @Published var recentRide: RecentRideInfo? = nil
    @Published var popularCourses: [CourseInfo] = []
    
    func fetchData() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let courseService = NetworkService<ChallengeAPI>()
                let myService = NetworkService<MyAPI>()
                
                let myInfoResponse = try await myService.request(.getMyInfo, responseDTO: MyInfoDTO.self)
                await setName(myInfoResponse.data.nickname)
                
                let recentResponse = try await myService.request(.getRecentMyRides, responseDTO: MyRecentRidesResponseDTO.self)
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
    private func setRecentRides(_ recentRide: RecentRideInfo?) {
        self.recentRide = recentRide
        if let recentRide = recentRide {
            self.isRecentRideExists = true
            self.isRecentRideDone = (recentRide.progressRate == 100 ? true : false)
        }
    }
    
    @MainActor
    private func setPopularCourses(_ popularCourses: [CourseInfo]) {
        self.popularCourses = popularCourses
    }
}
