//
//  CoreViewModel.swift
//  SaiSai
//
//  Created by ch on 7/9/25.
//

import Foundation

final class CoreViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var isSplashRepresented: Bool = true
    
    func validateToken() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let myInfoService = NetworkService<MyAPI>()
                let _ = try await myInfoService.request(.getMyInfo, responseDTO: MyInfoDTO.self)
                await viewTransitionWithDelay(isLoggedIn: true)
            } catch {
                await viewTransitionWithDelay()
            }
        }
    }
    
    @MainActor
    private func viewTransitionWithDelay(isLoggedIn: Bool = false) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoggedIn = isLoggedIn
            self?.isSplashRepresented = false
        }
    }
}

@MainActor
extension CoreViewModel: LoginViewModelDelegate {
    func isLoggedIn(_ isLoggedIn: Bool) {
        self.isLoggedIn = isLoggedIn
    }
}
