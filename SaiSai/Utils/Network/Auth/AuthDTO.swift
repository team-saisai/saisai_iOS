//
//  AuthDTO.swift
//  SaiSai
//
//  Created by ch on 7/9/25.
//

import Foundation

// MARK: - Request DTO
struct LoginRequestDTO: Codable {
    let email: String
    let password: String
}

struct RegisterRequestDTO: Codable {
    let email: String
    let nickname: String
    let password: String
    let role: String
}

// MARK: - Response DTO
struct LoginResponseDTO: Decodable {
    let code: String
    let message: String
    let data: TokenInfo
}

struct RegisterResponseDTO: Decodable {
    let code: String
    let message: String
    let data: TokenInfo
}

struct ReissueResponseDTO: Decodable {
    let code: String
    let message: String
    let data: TokenInfo
}

// MARK: - DataInfo
struct TokenInfo: Decodable {
    let accessToken: String
    let refreshToken: String
}
