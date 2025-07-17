//
//  ChallengeAPI.swift
//  SaiSai
//
//  Created by 이창현 on 7/13/25.
//

import Foundation
import Moya

enum ChallengeAPI {
    case getPopularChallenges
}

extension ChallengeAPI: TargetType {
    
    var path: String {
        switch self {
        case .getPopularChallenges:
            return "/api/challenges/popular"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPopularChallenges: .get
        }
    }
    
    var headers: [String: String]? {
        guard let accessToken = KeychainManagerImpl().retrieveToken(forKey: HTTPHeaderField.accessToken.rawValue) else {
            return nil
        }
        
        return [HTTPHeaderField.authorization.rawValue: accessToken]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

extension ChallengeAPI {
    var task: Moya.Task {
        switch self {
        case .getPopularChallenges:
            return .requestPlain
        }
    }
}
