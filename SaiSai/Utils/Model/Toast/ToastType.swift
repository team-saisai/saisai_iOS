//
//  ToastType.swift
//  SaiSai
//
//  Created by ch on 8/19/25.
//

import Foundation
import SwiftUI

enum ToastType {
    case requestFailure
    case withdrawSuccess
    case networkNotdetected
    case success(prefix: String)
    case distanceToFar
    case anotherRidingExists
    
    var toastText: String {
        switch self {
        case .requestFailure:
            "잠시 후 다시 시도해주세요."
        case .withdrawSuccess:
            "성공적으로 탈퇴했습니다."
        case .networkNotdetected:
            "네트워크 연결을 찾을 수 없습니다."
        case .success(let prefix):
            "\(prefix) 성공"
        case .distanceToFar:
            "출발점으로 이동 후 시작해주세요."
        case .anotherRidingExists:
            "라이딩 중인 코스가 존재합니다."
        }
    }
    
    var imageText: String {
        switch self {
        case .requestFailure, .networkNotdetected, .distanceToFar, .anotherRidingExists: "exclamationmark.triangle.fill"
        case .withdrawSuccess, .success: "checkmark.circle.fill"
        }
    }
    
    var imageColor: Color {
        switch self {
        case .requestFailure, .networkNotdetected, .distanceToFar, .anotherRidingExists: .red
        case .withdrawSuccess, .success: .customLime
        }
    }
}
