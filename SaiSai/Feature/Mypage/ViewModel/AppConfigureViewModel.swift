//
//  AppConfigureViewModel.swift
//  SaiSai
//
//  Created by ch on 8/16/25.
//

import CoreLocation
import Foundation

final class AppConfigureViewModel: ObservableObject {
    @Published var isLogoutAlertPresented: Bool = false
    @Published var isRemoveAccountAlertPresented: Bool = false
    
    weak var delegate: AppConfigureViewModelDelegate?
    
    let authService: NetworkService<AuthAPI> = .init()
    let keychainManager: KeychainManagerImpl = .init()
    
    init(delegate: AppConfigureViewModelDelegate?) {
        self.delegate = delegate
    }
    
    func requestLogout() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
//                let _ = try await authService.request(
//                    .logout,
//                    responseDTO: LogoutResponseDTO.self
//                )
                await deleteTokens()
                delegate?.logout()
            } catch {
                print("로그아웃 실패")
                print(error)
            }
        }
    }
    
    func requestRemoveAccount() {
        Task { [weak self] in
            guard let self = self else { return }
            // TODO: - 네트워크 요청
        }
    }
}

extension AppConfigureViewModel {
    @MainActor
    func setIsLogoutAlertPresented(_ isLogoutAlertPresented: Bool) {
        self.isLogoutAlertPresented = isLogoutAlertPresented
    }
    
    @MainActor
    func setIsRemoveAccountAlertPresented(_ isRemoveAccountAlertPresented: Bool) {
        self.isRemoveAccountAlertPresented = isRemoveAccountAlertPresented
    }
    
    @MainActor
    func removeAlert() {
        if isLogoutAlertPresented {
            isLogoutAlertPresented = false
        }
        if isRemoveAccountAlertPresented {
            isRemoveAccountAlertPresented = false
        }
    }
    
    @MainActor
    private func deleteTokens() {
        KeychainManagerImpl().deleteToken(forKey: HTTPHeaderField.accessToken.rawValue)
        KeychainManagerImpl().deleteToken(forKey: HTTPHeaderField.refreshToken.rawValue)
    }
}

protocol AppConfigureViewModelDelegate: AnyObject {
    func logout()
}
