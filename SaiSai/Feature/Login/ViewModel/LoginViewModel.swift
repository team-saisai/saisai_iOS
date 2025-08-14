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
    var googleOAuthUserData: GoogleOAuthUserData = .init()
    
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
    
    // MARK: - Kakao Login
    func requestKakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                guard let self = self else { return }
                if let error = error {
                    print(error)
                } else {
                    print("카카오 인증 요청 성공")
                    print(oauthToken)
//                    requestKakaoLoginToBackend(oauthToken)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                guard let self = self else { return }
                if let error = error {
                    print(error)
                } else {
                    print("카카오 인증 요청 성공")
                    print(oauthToken)
//                    requestKakaoLoginToBackend(oauthToken)
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
    
    // MARK: - Google Login
    func requestGoogleLogin() {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] _, error in
            guard let self = self else { return }
            
            if let error = error {
                print(error)
            }
            
            checkGoogleUserInfo()
            
            print("DEBUG : \(googleOAuthUserData)")
        }
    }
    
    private func checkGoogleUserInfo() {
        if GIDSignIn.sharedInstance.currentUser != nil {
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else { return }
            googleOAuthUserData.givenName = user.profile?.givenName ?? ""
            googleOAuthUserData.oauthId = user.userID ?? ""
            googleOAuthUserData.idToken = user.idToken?.tokenString ?? ""
        }
    }
    
    private func saveTokens(accessToken: String, refreshToken: String) {
        let _ = keychainManager.save(token: accessToken, forKey: HTTPHeaderField.accessToken.rawValue)
        let _ = keychainManager.save(token: refreshToken, forKey: HTTPHeaderField.refreshToken.rawValue)
    }
}

extension LoginViewModel: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = UIApplication.shared.windows.first else { // 현재 애플리케이션에서 활성화된 첫 번째 윈도우
            fatalError("No window found")
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
            
        default:
            break
        }
    }
}

@MainActor
protocol LoginViewModelDelegate: AnyObject {
    func isLoggedIn(_ isLoggedIn: Bool)
}
