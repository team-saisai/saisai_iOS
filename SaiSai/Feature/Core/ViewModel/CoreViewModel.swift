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
    
    let myInfoService = NetworkService<MyAPI>()
    
    func validateToken() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                KeychainManagerImpl().deleteToken(forKey: HTTPHeaderField.accessToken.rawValue)
                KeychainManagerImpl().deleteToken(forKey: HTTPHeaderField.refreshToken.rawValue)
                
                let _ = try await myInfoService.request(.getMyInfo, responseDTO: MyInfoDTO.self)
                await viewTransitionWithDelay(isLoggedIn: true)

                /// For Debug
                let access = KeychainManagerImpl().retrieveToken(forKey: HTTPHeaderField.accessToken.rawValue)
                let refresh = KeychainManagerImpl().retrieveToken(forKey: HTTPHeaderField.refreshToken.rawValue)
                
                print("---accessToken---")
                print(access)
                print("---refreshToken---")
                print(refresh)
            } catch {
                await viewTransitionWithDelay()
            }
        }
    }
    
    @MainActor
    private func viewTransitionWithDelay(isLoggedIn: Bool = false) {
        /// 빠른 실행을 위해 0으로 임시 수정
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) { [weak self] in
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
