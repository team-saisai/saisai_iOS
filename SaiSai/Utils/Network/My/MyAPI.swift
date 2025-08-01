//
//  MyAPI.swift
//  SaiSai
//
//  Created by 이창현 on 7/14/25.
//

import Foundation
import Moya

enum MyAPI {
    case getMyInfo
    case getRecentMyRides
}

extension MyAPI: TargetType {
    
    var path: String {
        switch self {
        case .getMyInfo:
            return "/api/my"
        case .getRecentMyRides:
            return "/api/my/rides"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getMyInfo, .getRecentMyRides: .get
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

extension MyAPI {
    var task: Moya.Task {
        switch self {
        case .getMyInfo, .getRecentMyRides:
            return .requestPlain
        }
    }
}
