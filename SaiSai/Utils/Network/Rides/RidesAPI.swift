//
//  RidesAPI.swift
//  SaiSai
//
//  Created by 이창현 on 7/24/25.
//

import Foundation
import Moya

enum RidesAPI {
    case startRides(courseId: Int)
    case pauseRides(rideId: Int, duration: Int, totalDistance: Double)
    case resumeRides(rideId: Int)
    case completeRides(rideId: Int, duration: Int, actualDistance: Double)
}

extension RidesAPI: TargetType {
    var path: String {
        switch self {
        case .startRides(let courseId):
            "/api/courses/\(courseId)/rides"
        case .pauseRides(let rideId, _, _):
            "/api/rides/\(rideId)/pause"
        case .resumeRides(let rideId):
            "/api/rides/\(rideId)/resume"
        case .completeRides(let rideId, _, _):
            "/api/rides/\(rideId)/complete"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .startRides: .post
        case .pauseRides, .resumeRides, .completeRides: .patch
        }
    }
    
    
    var headers: [String : String]? {
        guard let accessToken = KeychainManagerImpl().retrieveToken(forKey: HTTPHeaderField.accessToken.rawValue) else {
            return nil
        }
        
        return [
            HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
            HTTPHeaderField.authorization.rawValue:
                accessToken
        ]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

extension RidesAPI {
    var task: Moya.Task {
        switch self {
        case .startRides, .resumeRides:
            return .requestPlain
        case .pauseRides(_, let duration, let totalDistance):
            return .requestJSONEncodable(PauseRidesRequestDTO(duration: duration, totalDistance: totalDistance))
        case .completeRides(_, let duration, let actualDistance):
            return .requestJSONEncodable(CompleteRidesRequestDTO(duration: duration, actualDistance: actualDistance))
        }
    }
}
