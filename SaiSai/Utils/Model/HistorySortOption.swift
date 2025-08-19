//
//  HistorySortOption.swift
//  SaiSai
//
//  Created by ch on 8/19/25.
//

import Foundation

enum HistorySortOption: String, CaseIterable {
    case newest = "newest"
    case oldest = "oldest"
    
    var dropDownText: String {
        switch self {
        case .newest: "최신순"
        case .oldest: "오래된순"
        }
    }
}
