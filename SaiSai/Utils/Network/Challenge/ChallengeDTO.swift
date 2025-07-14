//
//  CourseDTO.swift
//  SaiSai
//
//  Created by 이창현 on 7/13/25.
//

import Foundation

// MARK: - Request DTO

// MARK: - ResponseDTO
struct PopularCourseResponseDTO: Decodable {
    let code: String
    let message: String
    let data: [CourseInfo]
}

// MARK: - DataInfo
struct CourseInfo: Decodable {
    let courseId: Int
    let courseName: String
    let level: Int /// 1 : 하, 2 : 중, 3 : 상
    let distance: Double
    let estimatedTime: Double
    let sigun: String
    let courseImageUrl: String?
    let challengeStatus: String /// ENDED(종료), ONGOING(진행), UPCOMING(예정)
    let endedAt: String
    let challengerCount: Int
    let isEventActive: Bool
    let reward: Int
}
