//
//  Auth.swift
//  SaiSai
//
//  Created by ch on 7/9/25.
//

import Foundation
import Moya

enum AccountRole: String {
    case user = "USER"
    case admin = "ADMIN"
}

enum AuthAPI {
    case login(email: String,
               password: String)
    
    case register(
        email: String,
        nickname: String,
        password: String,
        role: AccountRole)
    
    case reissue
}

extension AuthAPI: TargetType {
    
    var path: String {
        switch self {
        case .login:
            return "/api/auth/login"
        case .register:
            return "/api/auth/register"
        case .reissue:
            return "/api/auth/reissue"
        }
    }
    
    var method: Moya.Method { .post }
    
    var task: Moya.Task {
        switch self {
        case .login(let email, let password):
        case .register(
            let email,
            let nickname,
            let password,
            let role):
        case .reissue:
        }
    }
    
    var headers: [String : String]? {
        [
            HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue
        ]
    }
}
