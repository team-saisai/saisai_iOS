//
//  CourseAPI.swift
//  SaiSai
//
//  Created by 이창현 on 7/17/25.
//

import Foundation
import Moya

enum CourseAPI {
    case getCoursesList(page: Int? = nil, status: ChallengeStatus? = nil)
    case getCourseDetail(courseId: Int)
}

extension CourseAPI: TargetType {
    
    var path: String {
        switch self {
        case .getCoursesList:
            return "api/courses"
        case .getCourseDetail(let courseId):
            return "api/courses/\(courseId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCoursesList, .getCourseDetail: .get
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getCoursesList, .getCourseDetail:
            guard let accessToken = KeychainManagerImpl().retrieveToken(forKey: HTTPHeaderField.accessToken.rawValue) else {
                return nil
            }
            
            return [HTTPHeaderField.authorization.rawValue: accessToken]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

extension CourseAPI {
    var task: Moya.Task {
        switch self {
        case .getCoursesList(let page, let status):
            var params: [String: Any] = [:]
            if let page = page {
                params["page"] = page
            }
            if let status = status {
                params["challengeStatus"] = status.rawValue
            }
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.queryString)
        case .getCourseDetail:
            return .requestPlain
        }
    }
}
