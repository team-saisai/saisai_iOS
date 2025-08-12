//
//  HomeViewModel.swift
//  SaiSai
//
//  Created by 이창현 on 7/8/25.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var isLoading: Bool = true
    @Published var isRecentRideExists: Bool = false
    @Published var isRecentRideDone: Bool = false
    @Published var recentRide: RecentRideInfo? = nil
    @Published var popularChallenges: [CourseInfo] = []
    @Published var badgeIds: [Int] = []
    @Published var isRequestingBookmarks: Bool = false
    
    let challengeService = NetworkService<ChallengeAPI>()
    let myService = NetworkService<MyAPI>()
    let badgeService = NetworkService<BadgeAPI>()
    let courseService = NetworkService<CourseAPI>()
    
    func fetchData() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                
                let myInfoResponse = try await myService.request(.getMyInfo, responseDTO: MyInfoDTO.self)
                await setName(myInfoResponse.data.nickname)
                
                let recentResponse = try await myService.request(.getRecentMyRides, responseDTO: MyRecentRidesResponseDTO.self)
                let recent = recentResponse.data
                var isCompleted: Bool? = nil
                
                if let _ = recent {
                    let detailResponse = try await courseService.request(
                        .getCourseDetail(courseId: recent!.courseId),
                        responseDTO: CourseDetailResponseDTO.self)
                    isCompleted = detailResponse.data.isCompleted
                }
                await setRecentRides(recent, isCompleted)
                
                let popularResponse = try await challengeService.request(.getPopularChallenges, responseDTO: PopularChallengeResponseDTO.self)
                let populars = popularResponse.data
                await setPopularChallenges(populars)
                
                let badgeResponse = try await badgeService.request(.getBadgesList, responseDTO: MyBadgesListResponseDTO.self)
                let badges = badgeResponse.data.userBadgeIds
                await setBadges(badges)
                
                await toggleIsLoading(false)
            } catch {
                print("홈 정보 제공 실패 😭")
                print(error)
            }
        }
    }
    
    func requestBookmark(courseId: Int, index: Int, pastValue: Bool) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                await setIsRequestingBookmarks(true)
                if pastValue { // 북마크 해제 요청
                    let response = try await courseService.request(
                        .deleteBookmark(courseId: courseId),
                        responseDTO: BookmarkResponseDTO.self
                    )
                    await toggleBookmarkState(index, response.data.isCourseBookmarked)
                } else {
                    let response = try await courseService.request(
                        .saveBookmark(courseId: courseId),
                        responseDTO: BookmarkResponseDTO.self)
                    await toggleBookmarkState(index, response.data.isCourseBookmarked)
                }
                await setIsRequestingBookmarks(false)
            } catch {
                await setIsRequestingBookmarks(false)
                print("북마크 상태 변경 실패 🥲")
            }
        }
    }
}

// MARK: - Methods for updating UI
extension HomeViewModel {
    @MainActor
    private func setName(_ name: String) {
        self.name = name
    }
    
    @MainActor
    private func setRecentRides(_ recentRide: RecentRideInfo?, _ isCompleted: Bool?) {
        self.recentRide = recentRide
        if let _ = recentRide {
            self.isRecentRideExists = true
            if let isCompleted = isCompleted {
                self.isRecentRideDone = isCompleted
            }
        }
    }
    
    @MainActor
    private func setPopularChallenges(_ popularChallenges: [CourseInfo]) {
        self.popularChallenges = popularChallenges
    }
    
    @MainActor
    private func setBadges(_ badges: [Int]) {
        let numOfBadgeToAdd = 8 - badges.count
        var badgesToAdd: [Int] = []
        for _ in 0..<numOfBadgeToAdd {
            badgesToAdd.append(-1)
        }
        self.badgeIds = badges + badgesToAdd
    }
    
    @MainActor
    private func toggleIsLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    @MainActor
    func requestLocationPermission() {
        let locationManager = LocationPermissionManager()
        locationManager.locationManagerDidChangeAuthorization(locationManager.manager)
    }
    
    @MainActor
    func setIsRequestingBookmarks(_ isRequestingBookmarks: Bool) {
        self.isRequestingBookmarks = isRequestingBookmarks
    }
    
    @MainActor
    func toggleBookmarkState(_ index: Int, _ isBookmarked: Bool) {
        if popularChallenges.count <= index { return }
        self.popularChallenges[index].isBookmarked = isBookmarked
    }
}
