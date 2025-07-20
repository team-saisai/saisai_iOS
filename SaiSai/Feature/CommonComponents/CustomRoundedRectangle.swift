//
//  CustomRoundedRectangle.swift
//  SaiSai
//
//  Created by 이창현 on 7/18/25.
//

import SwiftUI

struct CustomRoundedRectangle: View {
    
    let radius: CGFloat
    let bgColor: Color
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let font: Font
    let text: String
    let hasFireImage: Bool
    
    init(radius: CGFloat,
         bgColor: Color,
         horizontalPadding: CGFloat = 9,
         verticalPadding: CGFloat = 6,
         text: String,
         font: Font = .pretendard(.medium, size: 12),
         hasFireImage: Bool = false) {
        self.radius = radius
        self.bgColor = bgColor
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.text = text
        self.font = font
        self.hasFireImage = hasFireImage
    }

    var body: some View {
        HStack(spacing: 3.5) {
            if hasFireImage {
                Image(.icFireIcon)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 12.5, height: 14)
            }
            Text(text)
                .font(font)
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .background(RoundedRectangle(cornerRadius: radius).fill(bgColor))
    }
}
