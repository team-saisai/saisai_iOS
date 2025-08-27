//
//  Date+.swift
//  SaiSai
//
//  Created by ch on 8/26/25.
//

import Foundation

extension Date {
    
    /// YYYY-MM-DD 형식의 날짜
    var yearMonthDayDate: String {
        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}
