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
        ZStack {
            Circle()
                .fill(Color.customLime)
                .frame(width: 16, height: 16)

            Image(systemName: "arrowtriangle.up.fill")
                .foregroundColor(.white)
                .rotationEffect(.degrees(heading))
                .offset(y: -12)
        }
    }
}
