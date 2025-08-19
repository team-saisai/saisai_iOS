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
    case getMyRecentRide
    case getMyRewards
    case getMyBookmarkedCourses(page: Int = 1)
    case deleteBookmarkedCourses(courseIds: [Int])
    case getMyProfile
    case deleteMyRides(rideIds: [Int])
    case getMyRides(
        page: Int = 1,
        sort: HistorySortOption = .newest,
        notCompletedOnly: Bool = false
    )
    case nicknameDuplicateCheck(nickname: String)
    case changeNickname(nickname: String)
//    case changeImage
}

extension MyAPI: TargetType {
    
    var path: String {
        switch self {
        case .getMyInfo:
            return "/my"
        case .getMyRecentRide:
            return "/my/rides/recent"
        case .getMyRewards:
            return "/my/rewards"
        case .getMyBookmarkedCourses, .deleteBookmarkedCourses:
            return "/my/bookmarks/courses"
        case .getMyProfile:
            return "/my/profile"
        case .deleteMyRides, .getMyRides:
            return "/my/rides"
        case .nicknameDuplicateCheck:
            return "/my/profile/nickname/check"
        case .changeNickname:
            return "/my/profile/nickname"
//        case .changeProfileImage:
//            return "/my/profile/image"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyInfo,
                .getMyRecentRide,
                .getMyRewards,
                .getMyBookmarkedCourses,
                .getMyProfile,
                .getMyRides,
                .nicknameDuplicateCheck
            : .get
        case .deleteBookmarkedCourses,
                .deleteMyRides
            : .delete
        case .changeNickname: .patch // + changeProfileImage
        }
    }
    
    var headers: [String: String]? {
        guard let accessToken = KeychainManagerImpl().retrieveToken(forKey: HTTPHeaderField.accessToken.rawValue) else {
            return nil
        }
        
        switch self {
        case .getMyInfo,
                .getMyRecentRide,
                .getMyRewards,
                .getMyBookmarkedCourses,
                .getMyProfile,
                .getMyRides,
                .nicknameDuplicateCheck
            : return [HTTPHeaderField.authorization.rawValue: accessToken]
        case .deleteBookmarkedCourses,
                .deleteMyRides,
                .changeNickname
            : return [
                HTTPHeaderField.authorization.rawValue: accessToken,
                HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue
            ]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

extension MyAPI {
    var task: Moya.Task {
        switch self {
        case .getMyInfo, .getMyRecentRide, .getMyRewards, .getMyProfile:
            return .requestPlain
            
        case .getMyBookmarkedCourses(let page):
            return .requestParameters(
                parameters:
                    ["page": page],
                encoding: URLEncoding.queryString
            )
            
        case .deleteBookmarkedCourses(let courseIds):
            return .requestJSONEncodable(MyBookmarkedCoursesDeleteRequestDTO(courseIds: courseIds))
            
        case .deleteMyRides(let rideIds):
            return .requestJSONEncodable(MyRidesDeleteRequestDTO(rideIds: rideIds))
            
        case .getMyRides(let page, let sort, let notCompletedOnly):
            return .requestParameters(
                parameters: [
                    "page": page,
                    "sort": sort.rawValue,
                    "notCompletedOnly": notCompletedOnly
                ],
                encoding: URLEncoding.queryString
            )
            
        case .nicknameDuplicateCheck(let nickname):
            return .requestParameters(
                parameters: ["nickname": nickname],
                encoding: URLEncoding.queryString
            )
            
        case .changeNickname(let nickname):
            return .requestJSONEncodable(ChangeNicknameRequestDTO(nickname: nickname))
        }
    }
}
