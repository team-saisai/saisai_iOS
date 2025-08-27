//
//  OAuthAuthenticator.swift
//  SaiSai
//
//  Created by ch on 8/19/25.
//

import Foundation
import KakaoSDKUser
import KakaoSDKCommon
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

final class OAuthAuthenticator: NSObject {
    
    static let shared: OAuthAuthenticator = .init()
    
    var requestToBackend: ((String) -> ())? = nil
    var isDelete: Bool = false
    
    private override init() { }
    
    func requestAppleLogin(
        requestToBackend: @escaping (String) -> (),
        isDelete: Bool = false
    ) {
        self.requestToBackend = nil
        self.requestToBackend = requestToBackend
        self.isDelete = isDelete
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func requestKakaoLogin(requestToBackend: @escaping (String) -> ()) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                if let error = error {
                    print(error)
                    self?.sendToast()
                } else {
                    let token = oauthToken?.accessToken as? String ?? ""
                    requestToBackend(token)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                if let error = error {
                    print(error)
                    self?.sendToast()
                } else {
                    let token = oauthToken?.accessToken as? String ?? ""
                    requestToBackend(token)
                }
            }
        }
    }
    
    func requestGoogleLogin(
        requestToBackend: @escaping (String) -> (),
        isDelete: Bool = false
    ) {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] _, error in
            guard let self = self else { return }
            
            if let error = error {
                print(error)
                self.sendToast()
            }
            
            let token = checkGoogleUserInfo(isDelete)
            
            requestToBackend(token)
        }
    }
//    
//    func requestGoogleRevoke() {
//        if GIDSignIn.sharedInstance.currentUser != nil {
//            GIDSignIn.sharedInstance.disconnect() { [weak self] error in
//                guard error == nil else {
//                    print("google revoke 실패...")
//                    self?.sendToast()
//                    return
//                }
//                print("google revoke 성공")
//            }
//        }
//    }
    
    private func checkGoogleUserInfo(_ isDelete: Bool) -> String {
        
        if GIDSignIn.sharedInstance.currentUser != nil {
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else { return "" }
            print("DEBUG: \(user.accessToken.tokenString)")
            if isDelete {
                return user.accessToken.tokenString
            } else {
                return user.idToken?.tokenString ?? ""
            }
        } else {
            return ""
        }
    }
}

extension OAuthAuthenticator: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
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
            
//            let userIdentifier = appleIDCredential.user //사용자 식별자
//            let nameComponents = appleIDCredential.fullName // 전체 이름
            let idToken = appleIDCredential.identityToken! // idToken
            let authorizationCode = appleIDCredential.authorizationCode!
            
            let authCode = String(data: authorizationCode, encoding: .utf8) ?? ""
            let token = String(data: idToken, encoding: .utf8) ?? ""
            
            if let requestToBackend = requestToBackend {
                requestToBackend(isDelete ? authCode : token)
            }
        default:
            break
        }
    }
    
    private func sendToast() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            ToastManager.shared.toastPublisher.send(.requestFailure)
        }
    }
}
