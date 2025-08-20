//
//  JoinDTO.swift
//  SaiSai
//
//  Created by ch on 8/20/25.
//

import Foundation

// MARK: - Request DTO
struct IsJoinRequestDTO: Codable {
    let token: String
}

// MARK: - Response DTO
struct IsJoinResponseDTO: Decodable {
    let code: String
    let message: String
    let data: DataInfo
    
    struct DataInfo: Decodable {
        let isNewUser: Bool
    }
}
