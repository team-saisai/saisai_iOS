//
//  MyDTO.swift
//  SaiSai
//
//  Created by 이창현 on 7/14/25.
//

import Foundation

// MARK: - Request DTO

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
