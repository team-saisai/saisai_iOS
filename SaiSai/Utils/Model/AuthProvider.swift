//
//  AuthProvider.swift
//  SaiSai
//
//  Created by ch on 8/19/25.
//

import Foundation

enum AuthProvider: String {
    case apple = "APPLE"
    case kakao = "KAKAO"
    case google = "GOOGLE"
    
    static func converToProvider(_ providerText: String) -> AuthProvider? {
        AuthProvider(rawValue: providerText.uppercased())
    }
}
