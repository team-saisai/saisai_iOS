//
//  RidesAPI.swift
//  SaiSai
//
//  Created by 이창현 on 7/24/25.
//

import Foundation
import Moya

enum RidesAPI {
    case syncRide(rideId: Int, duration: Int, checkpointIdx: Int)
    case startRides(courseId: Int)
    case pauseRides(rideId: Int, duration: Int, checkpointIdx: Int)
    case resumeRides(rideId: Int)
    case completeRides(rideId: Int, duration: Int)
}

extension RidesAPI: TargetType {
    var path: String {
        switch self {
        case .syncRide(let rideId, _, _):
            "/rides/\(rideId)/sync"
        case .startRides(let courseId):
            "/courses/\(courseId)/rides"
        case .pauseRides(let rideId, _, _):
            "/rides/\(rideId)/pause"
        case .resumeRides(let rideId):
            "/rides/\(rideId)/resume"
        case .completeRides(let rideId, _):
            "/rides/\(rideId)/complete"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .startRides: .post
        case .syncRide, .pauseRides, .resumeRides, .completeRides: .patch
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
        case .syncRide(_, let duration, let checkpointIdx):
            return .requestJSONEncodable(SyncRideRequestDTO(duration: duration, checkpointIdx: checkpointIdx))
        case .pauseRides(_, let duration, let checkpointIdx):
            return .requestJSONEncodable(PauseRidesRequestDTO(duration: duration, checkpointIdx: checkpointIdx))
        case .completeRides(_, let duration):
            return .requestJSONEncodable(CompleteRidesRequestDTO(duration: duration))
        }
    }
}
