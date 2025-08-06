//
//  Font+.swift
//  SaiSai
//
//  Created by yeosong on 7/5/25.
//
import SwiftUI

extension Font {
    // hakgoyansimSamulham 폰트 한종류
    static let hakgoyansimSamulham: Font = .custom("OTHakgyoansimSamulhamR", size: 22)
    
    enum Pretendard {
        case light
        case regular
        case medium
        case semibold
        case bold
        case extrabold
        case heavy
        
        var name: String {
            switch self {
            case .light:
                return "Pretendard-Light"
            case .regular:
                return "Pretendard-Regular"
            case .medium:
                return "Pretendard-Medium"
            case .semibold:
                return "Pretendard-Semibold"
            case .bold:
                return "Pretendard-Bold"
            case .extrabold:
                return "Pretendard-ExtraBold"
            case .heavy:
                return "Pretendard-Heavy"
            }
        }
    }
    // pretendard폰트 기본체는 medium
    // 사용법 - .font(.pretendard(.medium, 12))
    static func pretendard(_ weight: Pretendard = .medium, size: CGFloat) -> Font {
        return custom(weight.name, size: size)
    }
}
