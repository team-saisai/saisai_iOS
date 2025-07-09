//
//  LoginDTO.swift
//  SaiSai
//
//  Created by ch on 7/9/25.
//

import Foundation

struct LoginRequestDTO: Codable {
    let email: String
    let password: String
}

struct LoginResponseDTO: Decodable {
    let code: String
    let message: String
    let data: DataInfo
    
    struct DataInfo: Decodable {
        let accessToken: String
        let refreshToken: String
    }
}
