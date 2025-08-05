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
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let font: Font
    let text: String
    let hasFireImage: Bool
    let action: @MainActor () -> Void
    
    init(radius: CGFloat,
         bgColor: Color,
         horizontalPadding: CGFloat = 9,
         verticalPadding: CGFloat = 6,
         text: String,
         font: Font = .pretendard(.medium, size: 12),
         hasFireImage: Bool = false,
         action: @escaping @MainActor () -> Void) {
        self.radius = radius
        self.bgColor = bgColor
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.text = text
        self.font = font
        self.hasFireImage = hasFireImage
        self.action = action
    }
    
    var body: some View {
        Button(action: action, label: {
            CustomRoundedRectangle(radius: radius,
                                   bgColor: bgColor,
                                   horizontalPadding: horizontalPadding,
                                   verticalPadding: verticalPadding,
                                   text: text,
                                   font: font,
                                   hasFireImage: hasFireImage)
        })
    }
}
