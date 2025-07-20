//
//  LevelView.swift
//  SaiSai
//
//  Created by 이창현 on 7/20/25.
//

import SwiftUI

struct LevelView: View {
    
    let level: Int
    
    var body: some View {
        HStack(spacing: 2) {
            Text("난이도 ")
            switch level {
            case 1:
                Text("하")
                    .foregroundStyle(.levelLow)
            case 2:
                Text("중")
                    .foregroundStyle(.levelMiddle)
            case 3:
                Text("상")
                    .foregroundStyle(.levelHigh)
            default:
                Text("")
            }
        }
    }
}
