//
//  Theme.swift
//  SaiSai
//
//  Created by 이창현 on 7/20/25.
//

import Foundation

struct ThemeInfo {
    let themeId: Int
    let name: String
    var isSelected: Bool = false
    
    static var sampleList: [ThemeInfo] = [
        ThemeInfo(themeId: 1, name: "테마1"),
        ThemeInfo(themeId: 2, name: "테마2"),
        ThemeInfo(themeId: 3, name: "테마3"),
        ThemeInfo(themeId: 4, name: "테마4"),
        ThemeInfo(themeId: 5, name: "테마5"),
        ThemeInfo(themeId: 6, name: "테마6"),
    ]
}
