//
//  CourseDTO.swift
//  SaiSai
//
//  Created by 이창현 on 7/17/25.
//

import Foundation
import MapKit

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
}

struct CourseDetailResponseDTO: Decodable {
    let code: String
    let message: String
    let data: CourseDetailInfo
}

struct BookmarkResponseDTO: Decodable {
    let code: String
    let message: String
    let data: DataInfo
    
    struct DataInfo: Decodable {
        let isCourseBookmarked: Bool
    }
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
    let participantsCount: Int?
    var isBookmarked: Bool
    let challengeStatus: String?
    let challengeEndedAt: String?
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

struct PageInfo: Decodable {
    let pageNumber: Int
    let pageSize: Int
    let sort: SortInfo
    let offset: Int
    let unpaged: Bool
    let paged: Bool
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
    let isCompleted: Bool
    let rideId: Int? // null이면 CourseDetail, 있으면 CourseRiding
    let challengeStatus: String?
    let challengeEndedAt: String?
    let isEventActive: Bool?
    let gpxPoints: [GpxPointInfo]
    let checkPoints: [CheckPointInfo]
    
    var estimatedHour: Int {
        let totalTime = Int(estimatedTime)
        return totalTime / 60
    }
    
    var estimatedMinute: Int {
        let totalTime = Int(estimatedTime)
        return totalTime % 60
    }
    
    var challengeStatusCase: ChallengeStatus? {
        if let challengeStatus = challengeStatus, let status = ChallengeStatus(rawValue: challengeStatus) {
            return status
        } else {
            return nil
        }
    }
    
    var locations: [CLLocationCoordinate2D] {
        return gpxPoints.compactMap {
            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        }
    }
    
    var convertedSummary: String {
        return summary.replacingOccurrences(of: "<br>", with: "\n")
    }
}

struct GpxPointInfo: Decodable {
    let latitude: Double
    let longitude: Double
    let elevation: Double?
    let segmentDistance: Double
    let totalDistance: Double
}

struct CheckPointInfo: Decodable {
    let latitude: Double
    let longitude: Double
}
