//
//  JoinAPI.swift
//  SaiSai
//
//  Created by ch on 8/20/25.
//

import Foundation
import Moya

enum JoinAPI {
    case isJoinKakao(token: String)
    case isJoinGoogle(token: String)
    case isJoinApple(token: String)
}

extension JoinAPI: TargetType {
    
    var path: String {
        switch self {
        case .isJoinKakao:
            return "/kakao/isJoin"
        case .isJoinGoogle:
            return "/google/isJoin"
        case .isJoinApple:
            return "/apple/isJoin"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var headers: [String : String]? {
        return [
            HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue
        ]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

extension JoinAPI {
    var task: Moya.Task {
        switch self {
        case .isJoinApple(let token),
        .isJoinKakao(let token),
        .isJoinGoogle(let token):
            return .requestJSONEncodable(IsJoinRequestDTO(token: token))
        }
    }
}
