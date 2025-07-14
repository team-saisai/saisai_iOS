//
//  MyDTO.swift
//  SaiSai
//
//  Created by 이창현 on 7/14/25.
//

import Foundation

// MARK: - Request DTO
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
    let data: RecentRideInfo
}

// MARK: - Response DTO

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
