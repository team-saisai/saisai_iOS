//
//  Int+.swift
//  SaiSai
//
//  Created by ch on 7/15/25.
//

import Foundation

extension Int {
    
    /// 세 자리 단위로 끊어서 표현해주는 프로퍼티 => ex)1000 -> 1,000
    var commaDecimal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    var formattedTime: String {
        let hours = self / 3600
        let minutes = self % 3600 / 60
        let seconds = self % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
