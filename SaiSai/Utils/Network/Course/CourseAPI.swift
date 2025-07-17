//
//  CourseAPI.swift
//  SaiSai
//
//  Created by 이창현 on 7/17/25.
//

import Foundation
import Moya

enum CourseAPI {
    case getCoursesList(page: Int = 1, status: ChallengeStatus)
    case getCourseDetail(courseId: Int)
}

extension CourseAPI: TargetType {
    
    var path: String {
        switch self {
        case .getCoursesList:
            return "/v1/courses"
        case .getCourseDetail(let courseId):
            return "/v1/courses/\(courseId)"
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
            return .requestParameters(parameters: [
                "page": page,
                "status": status.rawValue
            ], encoding: URLEncoding.queryString)
        case .getCourseDetail:
            return .requestPlain
        }
    }
}
