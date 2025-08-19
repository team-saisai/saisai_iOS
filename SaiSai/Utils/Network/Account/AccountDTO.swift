//
//  AccountDTO.swift
//  SaiSai
//
//  Created by ch on 8/17/25.
//

import Foundation

// MARK: - Request DTO
struct AccountDeleteRequestDTO: Codable {
    let socialAccessToken: String
}

// MARK: - Response DTO
struct AccountDeleteResponseDTO: Decodable {
    let code: String
    let message: String
    let data: DataInfo
    
    struct DataInfo: Decodable {
        let provider: String?
    }
}
