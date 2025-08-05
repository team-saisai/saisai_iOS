//
//  RidesDTO.swift
//  SaiSai
//
//  Created by 이창현 on 7/24/25.
//

import Foundation

// MARK: - Request DTO
struct PauseRidesRequestDTO: Codable {
    let duration: Int
    let totalDistance: Double
}

struct CompleteRidesRequestDTO: Codable {
    let duration: Int
    let actualDistance: Double
}

// MARK: - Response DTO
struct StartRidesResponseDTO: Decodable {
    let code: String
    let message: String
    let data: DataInfo
    
    struct DataInfo: Decodable {
        let rideId: Int
        let sigun: String
        let courseName: String
        let distance: Double
        let gpxPoints: [GpxPointInfo]
    }
}

struct PauseRidesResponseDTO: Decodable {
    let code: String
    let message: String
    let data: DataInfo
    
    struct DataInfo: Decodable {
        let rideId: Int
    }
}

struct ResumeRidesResponseDTO: Decodable {
    let code: String
    let message: String
    let data: DataInfo
    
    struct DataInfo: Decodable {
        let rideId: Int
        let durationSecond: Int
        let actualDistance: Double
    }
}

struct CompleteRidesResponseDTO: Decodable {
    let code: String
    let message: String
    let data: EmptyData?
    
    struct EmptyData: Decodable {}
}

// MARK: - DataInfo
