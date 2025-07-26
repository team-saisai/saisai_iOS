//
//  CustomUserAnnotationView.swift
//  SaiSai
//
//  Created by 이창현 on 7/23/25.
//

import SwiftUI

struct CustomUserAnnotationView: View {
    
    var heading: Double
    
    var body: some View {
        Image(.directionIcon)
            .resizable()
            .frame(width: 32, height: 32)
            .rotationEffect(.degrees(heading))
    }
}
