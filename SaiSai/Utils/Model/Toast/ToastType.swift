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
    
    var toastText: String {
        switch self {
        case .requestFailure:
            "잠시 후 다시 시도해주세요."
        case .withdrawSuccess:
            "성공적으로 탈퇴했습니다."
        case .networkNotdetected:
            "네트워크 연결을 찾을 수 없습니다."
        }
    }
    
    var imageText: String {
        switch self {
        case .requestFailure, .networkNotdetected: "exclamationmark.triangle.fill"
        case .withdrawSuccess: "checkmark.circle.fill"
        }
    }
    
    var imageColor: Color {
        switch self {
        case .requestFailure, .networkNotdetected: .red
        case .withdrawSuccess: .customLime
        }
    }
}
