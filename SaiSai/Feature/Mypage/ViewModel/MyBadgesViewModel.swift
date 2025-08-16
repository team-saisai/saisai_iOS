//
//  MyBadgesViewModel.swift
//  SaiSai
//
//  Created by ch on 8/17/25.
//

import Foundation

final class MyBadgesViewModel: ObservableObject {
    
    @Published var isModalPresented: Bool = false
    @Published var badges: [BadgeInfo] = []
    @Published var modalBadge: BadgeInfo? = nil
    
    let myService: NetworkService<BadgeAPI> = .init()
    
    func fetchData() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let response = try await myService.request(
                    .getBadgesList,
                    responseDTO: MyBadgesListResponseDTO.self
                )
                await setBadges(response.data)
            } catch {
                print("뱃지 불러오기 실패")
                print(error)
            }
        }
    }
}

extension MyBadgesViewModel {
    @MainActor
    func setIsModalPresented(_ isModalPresented: Bool) {
        self.isModalPresented = isModalPresented
    }
    
    @MainActor
    func setModalBadge(_ badge: BadgeInfo) {
        self.modalBadge = badge
    }
    
    @MainActor
    private func setBadges(_ badges: [BadgeInfo]) {
        self.badges = badges
    }
}
