//
//  BadgeAPI.swift
//  SaiSai
//
//  Created by ch on 7/15/25.
//

import Foundation
import Moya

enum BadgeAPI {
    case getBadgesList
    case getBadgeDetail(badgeId: Int)
}

extension BadgeAPI: TargetType {
    
    var path: String {
        switch self {
        case .getBadgesList:
            "api/badges/me"
        case .getBadgeDetail(let badgeId):
            "api/badges/me/\(badgeId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBadgesList, .getBadgeDetail: .get
        }
    }
    
    var headers: [String : String]? {
        let accessToken = KeychainManagerImpl().retrieveToken(forKey: HTTPHeaderField.accessToken.rawValue) ?? ""
        return [HTTPHeaderField.authorization.rawValue: accessToken]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

extension BadgeAPI {
    var task: Moya.Task {
        switch self {
        case .getBadgesList, .getBadgeDetail:
            return .requestPlain
        }
    }
}
