//
//  API.swift
//  SaiSai
//
//  Created by ch on 7/9/25.
//

import Foundation

// MARK: - 로그인 가능 여부를 판별하기 위한 ** 임시 ** API => 추후에 Moya로 전환 예정

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

class API {
    let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""
}

extension API {
    func login(email: String, password: String) async throws -> LoginResponseDTO {
        let urlString = baseURL + "/api/auth/login"
        guard let url = URL(string: urlString) else {
            print("Failed to make URL")
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(
            LoginRequestDTO(email: email, password: password))
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }
        print("STATUS : \(response.statusCode)")
        
        switch response.statusCode {
        case 200..<300:
            return try JSONDecoder().decode(LoginResponseDTO.self, from: data)
        default:
            print("Failed to login")
            throw NetworkError.BadRequest
        }
    }
}

extension API {
    func reissue() async throws {
        let urlString = baseURL + "/api/auth/reissue"
        guard let url = URL(string: urlString) else {
            print("Failed to make URL")
            throw NetworkError.invalidURL
        }
    
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }
        
        print("STATUS : \(response.statusCode)")
        
        switch response.statusCode {
        case 200..<300:
            print("REISSUE SUCCESS")
            return
        default:
            print("Failed to login")
            throw NetworkError.BadRequest
        }
    }
}
