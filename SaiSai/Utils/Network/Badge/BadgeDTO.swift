//
//  BadgeDTO.swift
//  SaiSai
//
//  Created by 이창현 on 7/17/25.
//

import Foundation

// MARK: - Request DTO

// MARK: - Response DTO
struct MyBadgesListResponseDTO: Decodable {
    let code: String
    let message: String
    let data: [BadgeInfo]
}

struct BadgeDetailResponseDTO: Decodable {
    let code: String
    let message: String
    let data: DataInfo
    
    struct DataInfo: Decodable {
        let badgeName: String
        let badgeDescription: String
        let badgeImage: String
        let acquiredAt: String
    }
}

// MARK: - DataInfo
struct BadgeInfo: Decodable {
    let userBadgeId: Int
    let badgeName: String
    let badgeImageUrl: String
}
