//
//  LoginViewModel.swift
//  SaiSai
//
//  Created by ch on 7/9/25.
//

import Foundation
import KakaoSDKUser
import KakaoSDKCommon
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices
import Moya

final class LoginViewModel: NSObject, ObservableObject {
    @Published var emailText: String = "email"
    @Published var passwordText: String = "password"
    
    let authService = NetworkService<AuthAPI>()
    let joinService = NetworkService<JoinAPI>()
    let keychainManager = KeychainManagerImpl()
    
    weak var delegate: LoginViewModelDelegate?
    
    init(delegate: LoginViewModelDelegate) {
        self.delegate = delegate
    }
    
    func requestAppleLoginInJoin(_ token: String) {
        _Concurrency.Task { [weak self] in
            guard let self = self else { return }
            do {
                try await requestSocialLoginToBackend(.apple, token)
            } catch let error as MoyaError {
                if error.response?.statusCode == 400 {
                    DispatchQueue.main.async {
                        ToastManager.shared.toastPublisher.send(.requestFailure)
                    }
                }
                print("로그인 실패")
                print(error)
            }
            OAuthTokenStore.shared.initTokens()
        }
    }
    
    func requestKakaoLoginInJoin(_ token: String) {
        _Concurrency.Task { [weak self] in
            guard let self = self else { return }
            do {
                try await requestSocialLoginToBackend(.kakao, token)
            } catch let error as MoyaError {
                if error.response?.statusCode == 400 {
                    DispatchQueue.main.async {
                        ToastManager.shared.toastPublisher.send(.requestFailure)
                    }
                }
                print("로그인 실패")
                print(error)
            }
            OAuthTokenStore.shared.initTokens()
        }
    }
    
    func requestGoogleLoginInJoin(_ token: String) {
        _Concurrency.Task { [weak self] in
            guard let self = self else { return }
            do {
                try await requestSocialLoginToBackend(.google, token)
            } catch let error as MoyaError {
                if error.response?.statusCode == 400 {
                    DispatchQueue.main.async {
                        ToastManager.shared.toastPublisher.send(.requestFailure)
                    }
                }
                print("로그인 실패")
                print(error)
            }
            OAuthTokenStore.shared.initTokens()
        }
    }
    // MARK: - Apple Login
    func requestAppleLogin() {
        OAuthAuthenticator.shared.requestAppleLogin(requestToBackend: self.requestAppleLoginToBackend(_:))
    }
    
    private func requestAppleLoginToBackend(_ token: String) {
        _Concurrency.Task { [weak self] in
            guard let self = self else { return }
            do {
                try await requestisSocialJoinToBackend(.apple, token)
                try await requestSocialLoginToBackend(.apple, token)
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
        _Concurrency.Task { [weak self] in
            guard let self = self else { return }
            do {
                try await requestisSocialJoinToBackend(.kakao, token)
                try await requestSocialLoginToBackend(.kakao, token)
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
        _Concurrency.Task { [weak self] in
            guard let self = self else { return }
            do {
                try await requestisSocialJoinToBackend(.google, token)
                try await requestSocialLoginToBackend(.google, token)
            } catch {
                print("Google 로그인 실패😣")
                print(error)
            }
        }
    }
    
    // MARK: - Util Methods
    private func requestSocialLoginToBackend(_ provider: AuthProvider, _ token: String) async throws {
        var authType: AuthAPI {
            switch provider {
            case .apple: return .appleLogin(token: token)
            case .kakao: return .kakaoLogin(token: token)
            case .google: return .googleLogin(token: token)
            }
        }
        
        let response = try await authService.request(
            authType,
            responseDTO: OAuthLoginResponseDTO.self
        )
        
        let accessToken = response.data.accessToken
        let refreshToken = response.data.refreshToken
        saveTokens(accessToken: accessToken, refreshToken: refreshToken)
        
        await delegate?.isLoggedIn(true)
    }
    
    private func requestisSocialJoinToBackend(_ provider: AuthProvider, _ token: String) async throws {
        var joinType: JoinAPI {
            switch provider {
            case .apple: return .isJoinApple(token: token)
            case .kakao: return .isJoinKakao(token: token)
            case .google: return .isJoinGoogle(token: token)
            }
        }
        
        let response = try await joinService.request(
            joinType,
            responseDTO: IsJoinResponseDTO.self
        )
        if response.data.isNewUser {
            
            switch provider {
            case .apple:
                OAuthTokenStore.shared.setAppleToken(token)
                OAuthTokenStore.shared.completionHandler = requestAppleLoginInJoin(_:)
            case .kakao:
                OAuthTokenStore.shared.setKakaoToken(token)
                OAuthTokenStore.shared.completionHandler = requestKakaoLoginInJoin(_:)
            case .google:
                OAuthTokenStore.shared.setGoogleToken(token)
                OAuthTokenStore.shared.completionHandler = requestGoogleLoginInJoin(_:)
            }
            
            OAuthTokenStore.shared.provider = provider
            DispatchQueue.main.async {
                OAuthTokenStore.shared.isJoinPublisher.send()
            }
            throw MoyaError.statusCode(Response.init(statusCode: 300, data: Data()))
        }
    }
    
    private func saveTokens(accessToken: String, refreshToken: String) {
        let _ = keychainManager.save(token: accessToken, forKey: HTTPHeaderField.accessToken.rawValue)
        let _ = keychainManager.save(token: refreshToken, forKey: HTTPHeaderField.refreshToken.rawValue)
        print("---------4242 Access Token ---------")
        print(accessToken)
    }
}

extension LoginViewModel {
    // MARK: - 기존 로그인
    //    func requestLogin() {
    //        _Concurrency.Task { [weak self] in
    //            guard let self = self else { return }
    //            do {
    //                let response = try await authService.request(
    //                    .login(email: emailText, password: passwordText),
    //                    responseDTO: LoginResponseDTO.self)
    //
    //                let accessToken = response.data.accessToken
    //                let refreshToken = response.data.refreshToken
    //                saveTokens(accessToken: accessToken, refreshToken: refreshToken)
    //
    //                await delegate?.isLoggedIn(true)
    //            } catch {
    //                print("로그인 실패😣")
    //                print(error)
    //            }
    //        }
    //    }
}

@MainActor
protocol LoginViewModelDelegate: AnyObject {
    func isLoggedIn(_ isLoggedIn: Bool)
}
