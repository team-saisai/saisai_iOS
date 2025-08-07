//
//  AuthAPI.swift
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

// MARK: - Moya Properties
extension AuthAPI: TargetType {
    
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .register:
            return "/auth/register"
        case .reissue:
            return "/auth/reissue"
        }
    }
    
    var method: Moya.Method { .post }
    
    var headers: [String : String]? {
        var header: [String: String] = [:]
        switch self {
            
        case .reissue:
            let refreshToken = KeychainManagerImpl().retrieveToken(
                forKey: HTTPHeaderField.refreshToken.rawValue)
            header[HTTPHeaderField.authorization.rawValue] = refreshToken
            fallthrough
            
        default:
            header[HTTPHeaderField.contentType.rawValue] = ContentType.json.rawValue
        }
        return header
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

// MARK: - Moya Task
extension AuthAPI {
    var task: Moya.Task {
        switch self {
        case .login(let email, let password):
            return .requestJSONEncodable(LoginRequestDTO(
                email: email, password: password))
        case .register(let email, let nickname,
                       let password, let role):
            return .requestJSONEncodable(RegisterRequestDTO(
                email: email, nickname: nickname,
                password: password, role: role.rawValue))
        case .reissue:
            return .requestPlain
        }
    }
}
