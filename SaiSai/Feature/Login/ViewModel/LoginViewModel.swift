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
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

final class LoginViewModel: NSObject, ObservableObject {
    @Published var emailText: String = "email"
    @Published var passwordText: String = "password"
    
    var appleOAuthUserData: AppleOAuthUserData = .init()
    
    let authService = NetworkService<AuthAPI>()
    let keychainManager = KeychainManagerImpl()
    
    weak var delegate: LoginViewModelDelegate?
    
    init(delegate: LoginViewModelDelegate) {
        self.delegate = delegate
    }
    
    
    func requestLogin() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let response = try await authService.request(
                    .login(email: emailText, password: passwordText),
                    responseDTO: LoginResponseDTO.self)
                
                let accessToken = response.data.accessToken
                let refreshToken = response.data.refreshToken
                saveTokens(accessToken: accessToken, refreshToken: refreshToken)
                
                await delegate?.isLoggedIn(true)
            } catch {
                // TODO: - Alert logic 추가
                print("로그인 실패😣")
                print(error)
            }
        }
    }
    // MARK: - Apple Login
    func requestAppleLogin() {
        OAuthAuthenticator.shared.requestAppleLogin(requestToBackend: self.requestAppleLoginToBackend(_:))
    }
    
    func requestAppleLoginToBackend(_ token: String) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let response = try await authService.request(.appleLogin(token: token), responseDTO: OAuthLoginResponseDTO.self)
                
                let accessToken = response.data.accessToken
                let refreshToken = response.data.refreshToken
                saveTokens(accessToken: accessToken, refreshToken: refreshToken)
                
                await delegate?.isLoggedIn(true)
            } catch {
                print("Apple 로그인 실패😣")
                print(error)
            }
            
        }
    }
    
    // MARK: - Kakao Login
    func requestKakaoLogin() {
        OAuthAuthenticator.shared.requestKakaoLogin(requestToBackend: self.requestKakaoLoginToBackend(_:))
    }
    
    private func requestKakaoLoginToBackend(_ token: String) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let response = try await authService.request(.kakaoLogin(token: token), responseDTO: OAuthLoginResponseDTO.self)
                
                let accessToken = response.data.accessToken
                let refreshToken = response.data.refreshToken
                saveTokens(accessToken: accessToken, refreshToken: refreshToken)
                
                await delegate?.isLoggedIn(true)
            } catch {
                print("Kakao 로그인 실패😣")
                print(error)
            }
        }
    }
    
    // MARK: - Google Login
    func requestGoogleLogin() {
        OAuthAuthenticator.shared.requestGoogleLogin(requestToBackend: self.requestGoogleLoginToBackend(_:))
    }
    
    private func requestGoogleLoginToBackend(_ token: String) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let response = try await authService.request(
                    .googleLogin(token: token),
                    responseDTO: OAuthLoginResponseDTO.self
                )
                
                let accessToken = response.data.accessToken
                let refreshToken = response.data.refreshToken
                saveTokens(accessToken: accessToken, refreshToken: refreshToken)
                
                await delegate?.isLoggedIn(true)
            } catch {
                print("Google 로그인 실패😣")
                print(error)
            }
        }
    }
    
    private func saveTokens(accessToken: String, refreshToken: String) {
        let _ = keychainManager.save(token: accessToken, forKey: HTTPHeaderField.accessToken.rawValue)
        let _ = keychainManager.save(token: refreshToken, forKey: HTTPHeaderField.refreshToken.rawValue)
        print("---------4242 Access Token ---------")
        print(accessToken)
    }
}

@MainActor
protocol LoginViewModelDelegate: AnyObject {
    func isLoggedIn(_ isLoggedIn: Bool)
}
