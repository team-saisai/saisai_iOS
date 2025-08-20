//
//  OAuthTokenStore.swift
//  SaiSai
//
//  Created by ch on 8/20/25.
//

import Foundation
import Combine

struct OAuthTokenStore {
    
    static var shared: OAuthTokenStore = .init()
    
    let isJoinPublisher: PassthroughSubject<Void, Never> = .init()
    
    var appleToken: String = ""
    var kakaoToken: String = ""
    var googleToken: String = ""
    
    mutating func setAppleToken(_ token: String) {
        self.appleToken = token
    }
    
    mutating func setKakaoToken(_ token: String) {
        self.kakaoToken = token
    }
    
    mutating func setGoogleToken(_ token: String) {
        self.googleToken = token
    }
    
    mutating func initTokens() {
        self.appleToken = ""
        self.kakaoToken = ""
        self.googleToken = ""
    }
}
