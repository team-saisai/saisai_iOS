//
//  NetworkService.swift
//  SaiSai
//
//  Created by ch on 7/10/25.
//

import Foundation
import Moya

final class NetworkService<T: TargetType> {
    
    private let provider = MoyaProvider<T>()
    
    func request<D: Decodable>(_ target: T, responseDTO: D.Type) async throws -> D {
        do {
            return try await sendRequest(target, D.self)
        } catch NetworkError.reissue {
            try await reissue()
            return try await sendRequest(target, D.self)
        }
    }
    
    private func sendRequest<D: Decodable>(_ target: T, _ responseDTO: D.Type) async throws -> D {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let decoded = try JSONDecoder().decode(D.self, from: response.data)
                        continuation.resume(returning: decoded)
                    } catch {
                        if response.statusCode == 401 {
                            continuation.resume(throwing: NetworkError.reissue)
                        }
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

extension NetworkService {
    
    func reissue() async throws {
        
        print("--- REISSUE ---")
        
        let provider = MoyaProvider<AuthAPI>()
        
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.reissue) { result in
                switch result {
                case .success(let response):
                    do {
                        let response = try JSONDecoder().decode(ReissueResponseDTO.self, from: response.data)
                        
                        let _ = KeychainManagerImpl().save(
                            token: response.data.accessToken,
                            forKey: HTTPHeaderField.accessToken.rawValue)
                        let _ = KeychainManagerImpl().save(
                            token: response.data.refreshToken,
                            forKey: HTTPHeaderField.refreshToken.rawValue)
                        print("REISUE SUCCESS!")
                    } catch {
                        continuation.resume()
                    }
                case .failure:
                    continuation.resume(throwing: NetworkError.unauthroized)
                }
            }
        }
    }
}
