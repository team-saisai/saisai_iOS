//
//  MyRewardsViewModel.swift
//  SaiSai
//
//  Created by ch on 8/17/25.
//

import Foundation

final class MyRewardsViewModel: ObservableObject {
    
    @Published var rewardsList: [RewardInfo] = []
    @Published var totalReward: Int = 0

    let myService: NetworkService<MyAPI> = .init()
    
    func fetchData() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let response = try await myService.request(
                    .getMyRewards,
                    responseDTO: MyRewardsResponseDTO.self
                )
                let rewardsList = response.data.rewardInfos
                let totalReward = response.data.totalReward
                
                await setRewardsList(rewardsList)
                await setTotalReward(totalReward)
            } catch {
                
            }
        }
    }
}

extension MyRewardsViewModel {
    @MainActor
    func setRewardsList(_ rewardsList: [RewardInfo]) {
        self.rewardsList = rewardsList
    }
    
    @MainActor
    func setTotalReward(_ totalReward: Int) {
        self.totalReward = totalReward
    }
}
