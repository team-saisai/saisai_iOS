//
//  AccountAPI.swift
//  SaiSai
//
//  Created by ch on 8/17/25.
//

import Foundation
import Moya

enum AccountAPI {
    case removeAccount(token: String)
}

extension AccountAPI: TargetType {
    
    var path: String {
        switch self {
        case .removeAccount:
            "/auth/withdraw"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .removeAccount: .delete
        }
    }
    
    var headers: [String : String]? {
        guard let accessToken = KeychainManagerImpl().retrieveToken(forKey: HTTPHeaderField.accessToken.rawValue) else {
            return nil
        }
        
        switch self {
        case .removeAccount:
            return [
                HTTPHeaderField.authorization.rawValue: accessToken,
                HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue
            ]
        }
    }

    var validationType: ValidationType {
        return .successCodes
    }
}

extension AccountAPI {
    var task: Moya.Task {
        switch self {
        case .removeAccount(let token):
            return .requestJSONEncodable(
                AccountDeleteRequestDTO(
                    socialAccessToken: token
                )
            )
        }
    }
}
