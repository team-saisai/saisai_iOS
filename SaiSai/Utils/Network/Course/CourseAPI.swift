//
//  CourseAPI.swift
//  SaiSai
//
//  Created by 이창현 on 7/17/25.
//

import Foundation
import Moya

enum CourseAPI {
    case getCoursesList(page: Int? = nil, isChallenge: Bool = true, sort: CourseSortOption = .levelAsc)
    case getCourseDetail(courseId: Int)
    case saveBookmark(courseId: Int)
    case deleteBookmark(courseId: Int)
}

extension CourseAPI: TargetType {
    
    var path: String {
        switch self {
        case .getCoursesList:
            return "api/courses"
        case .getCourseDetail(let courseId):
            return "api/courses/\(courseId)"
        case .saveBookmark(let courseId), .deleteBookmark(let courseId):
            return "api/courses/\(courseId)/bookmarks"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCoursesList, .getCourseDetail: .get
        case .saveBookmark:
            .post
        case .deleteBookmark:
            .delete
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getCoursesList, .getCourseDetail:
            guard let accessToken = KeychainManagerImpl().retrieveToken(forKey: HTTPHeaderField.accessToken.rawValue) else {
                return nil
            }
            
            return [HTTPHeaderField.authorization.rawValue: accessToken]
        case .saveBookmark, .deleteBookmark:
            guard let accessToken = KeychainManagerImpl().retrieveToken(forKey: HTTPHeaderField.accessToken.rawValue) else { return nil }
            return [
                HTTPHeaderField.authorization.rawValue: accessToken,
                HTTPHeaderField.contentType.rawValue:
                    ContentType.json.rawValue
            ]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

extension CourseAPI {
    var task: Moya.Task {
        switch self {
        case .getCoursesList(let page, let isChallenge, let sort):
            let courseType = isChallenge ? "challenge" : "general"
            var params: [String: Any] = [
                "type": courseType,
                "sort": sort.rawValue
            ]
            if let page = page {
                params["page"] = page
            }
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.queryString)
        case .getCourseDetail, .saveBookmark, .deleteBookmark:
            return .requestPlain
        }
    }
}
