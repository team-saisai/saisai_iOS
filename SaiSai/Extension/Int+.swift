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
}
