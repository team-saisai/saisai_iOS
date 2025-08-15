//
//  CourseSortOption.swift
//  SaiSai
//
//  Created by 이창현 on 8/1/25.
//

import Foundation

enum CourseSortOption: String, CaseIterable {
    case levelAsc = "levelAsc"
    case levelDesc = "levelDesc"
    case participantsDesc = "participantsDesc"
    case endSoon = "endSoon"
    
    var dropDownText: String {
        switch self {
        case .levelAsc: "난이도 낮은 순"
        case .levelDesc: "난이도 높은 순"
        case .participantsDesc: "참가자 순"
        case .endSoon: "종료일 순"
        }
    }
}

enum CourseHistorySortOption: String, CaseIterable {
    case newest = "newest"
    case oldest = "oldest"
}
