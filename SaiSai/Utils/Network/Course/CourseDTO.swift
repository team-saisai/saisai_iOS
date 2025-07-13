//
//  CourseDTO.swift
//  SaiSai
//
//  Created by 이창현 on 7/13/25.
//

import Foundation

// MARK: - Request DTO

// MARK: - ResponseDTO
struct MyRecentRidesResponseDTO: Decodable {
    let code: String
    let message: String
    let data: [RecentRideInfo]
}

struct PopularCourseResponseDTO: Decodable {
    let code: String
    let message: String
    let data: [CourseInfo]
}

// MARK: - DataInfo
struct RecentRideInfo: Decodable {
    let courseId: Int
    let courseNme: String
    let sigun: String
    let courseImageUrl: String?
    let distance: CGFloat
    let progressRate: Int
    let recentRideAt: String
}

struct CourseInfo: Decodable {
    let courseId: Int
    let courseName: String
    let level: String
    let distance: CGFloat
    let estimatedTime: CGFloat
    let sigun: String
    let courseImageUrl: String?
    let challengeStatus: String
    let endedAt: String
    let challengerCount: Int
}
