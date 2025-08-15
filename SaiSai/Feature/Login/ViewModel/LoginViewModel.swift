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
            }
        }
    }
    // MARK: - Apple Login
    func requestAppleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func requestAppleLoginToBackend() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let response = try await authService.request(.appleLogin(token: appleOAuthUserData.idToken), responseDTO: OAuthLoginResponseDTO.self)
                
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
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                guard let self = self else { return }
                if let error = error {
                    print(error)
                } else {
                    let token = oauthToken?.accessToken as? String ?? ""
                    requestKakaoLoginToBackend(token)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                guard let self = self else { return }
                if let error = error {
                    print(error)
                } else {
                    let token = oauthToken?.accessToken as? String ?? ""
                    requestKakaoLoginToBackend(token)
                }
            }
        }
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
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] _, error in
            guard let self = self else { return }
            
            if let error = error {
                print(error)
            }
            
            let token = checkGoogleUserInfo()
            
            requestGoogleLoginToBackend(token)
        }
    }
    
    private func requestGoogleLoginToBackend(_ token: String) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                print(token)
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
    
    private func checkGoogleUserInfo() -> String {
        if GIDSignIn.sharedInstance.currentUser != nil {
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else { return "" }
            return user.idToken?.tokenString ?? ""
        } else {
            return ""
        }
    }
    
    private func saveTokens(accessToken: String, refreshToken: String) {
        let _ = keychainManager.save(token: accessToken, forKey: HTTPHeaderField.accessToken.rawValue)
        let _ = keychainManager.save(token: refreshToken, forKey: HTTPHeaderField.refreshToken.rawValue)
    }
}

extension LoginViewModel: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared
            .connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              
                let window = windowScene.windows.first else {
            fatalError("No active window found.")
        }
        
        return window
    }
    
    func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential { // 인증 정보에 따라 다르게 처리
        case let appleIDCredential as ASAuthorizationAppleIDCredential://Apple ID 자격 증명을 처리
            
            let userIdentifier = appleIDCredential.user //사용자 식별자
            let nameComponents = appleIDCredential.fullName // 전체 이름
            let idToken = appleIDCredential.identityToken! // idToken
            
            appleOAuthUserData.oauthId = userIdentifier
            appleOAuthUserData.idToken = String(data: idToken, encoding: .utf8) ?? ""
            
            requestAppleLoginToBackend()
        default:
            break
        }
    }
}

@MainActor
protocol LoginViewModelDelegate: AnyObject {
    func isLoggedIn(_ isLoggedIn: Bool)
}
