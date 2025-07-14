//
//  RoundedButton.swift
//  SaiSai
//
//  Created by 이창현 on 7/14/25.
//

import SwiftUI

struct RoundedButton: View {

    let radius: CGFloat
    let bgColor: Color
    let text: String
    let action: @MainActor () -> Void
    
    init(radius: CGFloat,
         bgColor: Color,
         text: String,
         action: @escaping @MainActor () -> Void) {
        self.radius = radius
        self.bgColor = bgColor
        self.text = text
        self.action = action
    }
    
    var body: some View {
        Button(action: action, label: {
            Text(text)
                .foregroundStyle(.white)
                .font(.pretendard(.medium, size: 12))
        })
        .padding(.horizontal, 9)
        .padding(.vertical, 6)
        .background(RoundedRectangle(cornerRadius: radius).fill(bgColor))
    }
}
