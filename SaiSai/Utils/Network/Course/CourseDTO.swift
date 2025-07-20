//
//  CourseDTO.swift
//  SaiSai
//
//  Created by 이창현 on 7/17/25.
//

import Foundation

// MARK: - Request DTO

// MARK: - Response DTO
struct AllCourseListResponse: Decodable {
    let code: String
    let message: String
    let data: DataInfo
    
    struct DataInfo: Decodable {
        let content: [CourseContentInfo]
        let pageable: PageInfo
        let totalElements: Int
        let totalPages: Int
        let last: Bool
        let size: Int
        let number: Int
        let sort: SortInfo
        let numberOfElements: Int
        let first: Bool
        let empty: Bool
    }
    
    struct PageInfo: Decodable {
        let pageNumber: Int
        let pageSize: Int
        let sort: SortInfo
        let offset: Int
        let unpaged: Bool
        let paged: Bool
    }
}

struct CourseDetailResponseDTO: Decodable {
    let code: String
    let message: String
    let data: CourseDetailInfo
}

// MARK: - DataInfo
struct CourseContentInfo: Decodable {
    let courseId: Int
    let courseName: String
    let level: Int
    let distance: Double
    let estimatedTime: Double
    let sigun: String
    let imageUrl: String?
    let courseChallengerCount: Int
    let courseFinisherCount: Int
    let challengeStatus: String
    let challengeEndedAt: String
    let isEventActive: Bool
    let reward: Int
    let themeNames: [String]
    
    var challengeStatusCase: ChallengeStatus {
        if let challengeStatus = ChallengeStatus(rawValue: challengeStatus) {
            return challengeStatus
        } else {
            print("received wrong challengeStatus: \(challengeStatus)")
            return .ongoing
        }
    }
}

struct SortInfo: Decodable {
    let empty: Bool
    let unsorted: Bool
    let sorted: Bool
}

struct CourseDetailInfo: Decodable {
    let courseId: Int
    let courseName: String
    let summary: String
    let level: Int
    let distance: Double
    let estimatedTime: Double
    let sigun: String
    let imageUrl: String?
    let challengerCount: Int
    let finisherCount: Int
    let hasUncompletedRide: Bool
    let themeNames: [String]
    let gpxPoints: [GpxPointInfo]
}

struct GpxPointInfo: Decodable {
    let latitude: Double
    let longitude: Double
    let elevation: Double
    let segmentDistance: Double
    let totalDistance: Double
}
