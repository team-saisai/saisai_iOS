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
    @Published var popularChallenges: [CourseInfo] = []
    @Published var badges: [BadgeInfo] = []
    var eightBadgesList: [[BadgeInfo]] {
        stride(from: 0, to: badges.count, by: 8).map { index in
            Array(badges[index..<min(index + 8, badges.count)])
        }
    }
    
    func fetchData() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let challengeService = NetworkService<ChallengeAPI>()
                let myService = NetworkService<MyAPI>()
                let badgeService = NetworkService<BadgeAPI>()
                
                let myInfoResponse = try await myService.request(.getMyInfo, responseDTO: MyInfoDTO.self)
                await setName(myInfoResponse.data.nickname)
                
                let recentResponse = try await myService.request(.getRecentMyRides, responseDTO: MyRecentRidesResponseDTO.self)
                let recent = recentResponse.data
                await setRecentRides(recent)
                
                let popularResponse = try await challengeService.request(.getPopularChallenges, responseDTO: PopularChallengeResponseDTO.self)
                let populars = popularResponse.data
                await setPopularChallenges(populars)
                
                let badgeResponse = try await badgeService.request(.getBadgesList, responseDTO: MyBadgesListResponseDTO.self)
                let badges = badgeResponse.data
                await setBadges(badges)
            } catch {
                print("홈 정보 제공 실패 😭")
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
    private func setRecentRides(_ recentRide: RecentRideInfo?) {
        self.recentRide = recentRide
        if let recentRide = recentRide {
            self.isRecentRideExists = true
            self.isRecentRideDone = (recentRide.progressRate == 100 ? true : false)
        }
    }
    
    @MainActor
    private func setPopularChallenges(_ popularChallenges: [CourseInfo]) {
        self.popularChallenges = popularChallenges
    }
    
    @MainActor
    private func setBadges(_ badges: [BadgeInfo]) {
        let numOfBadgeToAdd = 8 - badges.count % 8
        var badgesToAdd: [BadgeInfo] = []
        for _ in 0..<numOfBadgeToAdd {
            badgesToAdd.append(.init(userBadgeId: 0, badgeName: "", badgeImageUrl: ""))
        }
        self.badges = badges + badgesToAdd
    }
}
