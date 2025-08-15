//
//  MyDTO.swift
//  SaiSai
//
//  Created by 이창현 on 7/14/25.
//

import Foundation

// MARK: - Request DTO
struct MyBookmarkedCoursesDeleteRequestDTO: Codable {
    let courseIds: [Int]
}

struct MyRidesDeleteRequestDTO: Codable {
    let rideIds: [Int]
}

struct ChangeNicknameRequestDTO: Codable {
    let nickname: String
}

// MARK: - Response DTO
struct MyInfoDTO: Decodable {
    let code: String
    let message: String
    let data: DataInfo
    
    struct DataInfo: Decodable {
        let nickname: String
    }
}

struct MyRecentRidesResponseDTO: Decodable {
    let code: String
    let message: String
    let data: RecentRideInfo?
}

struct MyProfileResponseDTO: Decodable {
    let code: String
    let message: String
    let data: ProfileInfo
}

struct MyRewardsResponseDTO: Decodable {
    let code: String
    let message: String
    let data: DataInfo
    
    struct DataInfo: Decodable {
        let totalReward: Int
        let rewardInfos: [RewardInfo]
        
        struct RewardInfo: Decodable {
            let reward: Int
            let acquiredAt: String // should check
            let courseName: String
        }
    }
}

struct MyBookmarkedCoursesResponseDTO: Decodable {
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

struct MyBookmarkedCoursesDeleteResponseDTO: Decodable {
    let code: String
    let message: String
    let data: DataInfo
    
    struct DataInfo: Decodable {
        let deleteCount: Int
    }
}

struct MyRidesDeleteResponseDTO: Decodable {
    let code: String
    let message: String
    let data: DataInfo
     
     
    struct DataInfo: Decodable {
        let deleteCount: Int
    }
}

struct MyRidesResponseDTO: Decodable {
    let code: String
    let message: String
    let data: DataInfo
    
    struct DataInfo: Decodable {
        let content: [MyRidesInfo]
    }
}

struct ChangeNicknameResponseDTO: Decodable {
    let code: String
    let message: String
    let data: DataInfo?
    
    struct DataInfo: Decodable {
        let nickname: String
    }
}

// MARK: - DataInfo
struct RecentRideInfo: Decodable {
    let courseId: Int
    let courseName: String
    let sigun: String
    let courseImageUrl: String?
    let distance: Float
    let progressRate: Int
    let recentRideAt: String
}

struct ProfileInfo: Decodable {
    let imageUrl: String?
    let nickname: String
    let email: String
    let rideCount: Int
    let bookmarkCount: Int
    let reward: Int
    let badgeCount: Int
    
    init() {
        self.imageUrl = nil
        self.nickname = ""
        self.email = ""
        self.rideCount = 0
        self.bookmarkCount = 0
        self.reward = 0
        self.badgeCount = 0
    }
}

struct MyRidesInfo: Decodable {
    let rideId: Int?
    let courseId: Int
    let courseName: String
    let sigun: String
    let level: Int
    let lastRideDate: String
    let distance: Double
    let estimatedTime: Int
    let progressRate: Int
    let imageUrl: String?
    let isCompleted: Bool
    let challengeStatus: String? // ONGOING(진행), null
    let challengedEndedAt: String? // 챌린지 기간 아니면 null
    let isEventActive: Bool? // 챌린지 아니면 null
    
    var challengeStatusCase: ChallengeStatus? {
        if let challengeStatus = challengeStatus, let status = ChallengeStatus(rawValue: challengeStatus) {
            return status
        } else {
            return nil
        }
    }
}
