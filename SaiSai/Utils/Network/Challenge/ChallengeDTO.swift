//
//  CourseDTO.swift
//  SaiSai
//
//  Created by 이창현 on 7/13/25.
//

import Foundation

// MARK: - Request DTO

// MARK: - ResponseDTO
struct PopularChallengeResponseDTO: Decodable {
    let code: String
    let message: String
    let data: [CourseInfo]
}

// MARK: - DataInfo
struct CourseInfo: Decodable {
    let courseId: Int
    let courseName: String
    let level: Int
    let distance: Double
    let estimatedTime: Double
    let sigun: String
    let courseImageUrl: String?
    let challengeStatus: String?
    let endedAt: String
//    let isBookmarked: Bool
    let challengerCount: Int?
    let isEventActive: Bool?
    let reward: Int?
    
    var challengeStatusCase: ChallengeStatus? {
        if let challengeStatus = challengeStatus, let status = ChallengeStatus(rawValue: challengeStatus) {
            return status
        } else {
            return nil
        }
    }
}
