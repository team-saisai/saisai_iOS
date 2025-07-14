//
//  String+.swift
//  SaiSai
//
//  Created by 이창현 on 7/14/25.
//

import Foundation

extension String {
    
    /// YYYY-MM-DD 형식의 String을 YYYY.MM.DD와 같은 format으로 전환해주는 메서드
    var dottedDateText: String {
        let newString = self.replacingOccurrences(of: "-", with: ".")
        return newString
    }
    
    /// YYYY-MM-DD 형식의 String을 M/DD, MM/DD와 같은 format으로 전환해주는 메서드
    var slashDateText: String {
        let splittedArr = self.split(separator: ".")
        
        if splittedArr.count != 3 { return "" }
        
        let month = Int(splittedArr[0]) ?? 0
        let day = Int(splittedArr[0]) ?? 0
        
        return ("\(month)/\(day)")
    }
}
