//
//  SaiSaiApp.swift
//  SaiSai
//
//  Created by yeosong on 7/5/25.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn
import GoogleSignInSwift

@main
struct SaiSaiApp: App {
    
    init() {
        // MARK: - KAKAO SDK init
        let kakaoNativeAppKey = (Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String ?? "")
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            CoreView()
                .onOpenURL {
                    url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                    GIDSignIn.sharedInstance.handle(url)
                }
//                .onAppear {
//                    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
//                        // Check if `user` exists; otherwise, do something with `error`
//                    }
//                }
        }
    }
}
