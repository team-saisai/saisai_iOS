//
//  LoginViewModel.swift
//  SaiSai
//
//  Created by ch on 7/9/25.
//

import Foundation
import Combine
import KakaoSDKUser
import KakaoSDKCommon

final class LoginViewModel: ObservableObject {
    @Published var emailText: String = "email"
    @Published var passwordText: String = "password"
    
    let service = NetworkService<AuthAPI>()
    let keychainManager = KeychainManagerImpl()
    
    weak var delegate: LoginViewModelDelegate?
    
    init(delegate: LoginViewModelDelegate) {
        self.delegate = delegate
    }
    
    
    func requestLogin() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let response = try await service.request(
                    .login(email: emailText, password: passwordText),
                    responseDTO: LoginResponseDTO.self)
                
                let accessToken = response.data.accessToken
                let refreshToken = response.data.refreshToken
                saveTokens(accessToken: accessToken, refreshToken: refreshToken)
                
                await delegate?.isLoggedIn(true)
            } catch {
                // TODO: - Alert logic 추가
                print("로그인 실패😣")
            }
        }
    }
    
    func requestKakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            print("A")
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                print("C")
                guard let self = self else { return }
                if let error = error {
                    print(error)
                } else {
                    print("카카오 인증 요청 성공")
                    requestKakaoLoginToBackend(oauthToken)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                print("B")
                guard let self = self else { return }
                if let error = error {
                    print(error)
                } else {
                    print("카카오 인증 요청 성공")
                    requestKakaoLoginToBackend(oauthToken)
                }
            }
        }
    }
    
    private func requestKakaoLoginToBackend(_ oauthToken: Any?) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                await delegate?.isLoggedIn(true)
                print("TOKEN: \(oauthToken)")
                print("카카오 로그인 성공")
            } catch {
                print("카카오 로그인 실패😣")
                print(error)
            }
        }
    }
    
    private func saveTokens(accessToken: String, refreshToken: String) {
        let _ = keychainManager.save(token: accessToken, forKey: HTTPHeaderField.accessToken.rawValue)
        let _ = keychainManager.save(token: refreshToken, forKey: HTTPHeaderField.refreshToken.rawValue)
    }
}

@MainActor
protocol LoginViewModelDelegate: AnyObject {
    func isLoggedIn(_ isLoggedIn: Bool)
}
