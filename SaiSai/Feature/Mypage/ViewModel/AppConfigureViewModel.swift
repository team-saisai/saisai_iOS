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
    let accountService: NetworkService<AccountAPI> = .init()
    let keychainManager: KeychainManagerImpl = .init()
    let authProvider: AuthProvider?
    
    init(
        delegate: AppConfigureViewModelDelegate?,
        authProvider: AuthProvider?
    ) {
        self.delegate = delegate
        self.authProvider = authProvider
    }
    
    func requestLogout() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let _ = try await authService.request(
                    .logout,
                    responseDTO: LogoutResponseDTO.self
                )
                await deleteTokens()
                delegate?.logout()
            } catch {
                print("로그아웃 실패")
                print(error)
            }
        }
    }
    
    func requestRemoveAccount() {
        guard let authProvider = authProvider else { return }
        switch authProvider {
        case .apple:
            OAuthAuthenticator.shared.requestAppleLogin(
                requestToBackend: requestRemoveAccountToBackend(_:),
                isDelete: true
            )
        case .kakao:
            OAuthAuthenticator.shared.requestKakaoLogin(requestToBackend: requestRemoveAccountToBackend(_:))
        case .google:
            OAuthAuthenticator.shared.requestGoogleLogin(requestToBackend: revokeGoogleAccount(_:))
            
        }
    }
    
    func requestRemoveAccountToBackend(_ token: String) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let _ = try await accountService.request(
                    .removeAccount(
                        token: token
                    ),
                    responseDTO: AccountDeleteResponseDTO.self
                )
                await deleteTokens()
                delegate?.logout()
                await sendToast()
            } catch {
                print("회원탈퇴 실패")
                print(error)
            }
        }
    }
    
    func revokeGoogleAccount(_ token: String) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
//                let _ = try await accountService.request(
//                    .removeAccount(
//                        token: token
//                    ),
//                    responseDTO: AccountDeleteResponseDTO.self
//                )
                OAuthAuthenticator.shared.requestGoogleRevoke()
                await deleteTokens()
                delegate?.logout()
                await sendToast()
            } catch {
                print("회원탈퇴 실패")
                print(error)
            }
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
    
    @MainActor
    private func sendToast() {
        ToastManager.shared.toastPublisher.send(.withdrawSuccess)
    }
}

protocol AppConfigureViewModelDelegate: AnyObject {
    func logout()
}
