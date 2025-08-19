//
//  CustomToastView.swift
//  SaiSai
//
//  Created by ch on 8/19/25.
//

import SwiftUI

struct CustomToastView: View {
    
    @Binding var toastType: ToastType
    @ObservedObject var vm: CoreViewModel
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: toastType.imageText)
                .foregroundStyle(toastType.imageColor)
            
            Text(toastType.toastText)
                .font(.pretendard(size: 12))
                .foregroundStyle(.gray90)
            
            Spacer()
            
            Button {
                withAnimation {
                    vm.setIsToastPresented(false)
                }
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.gray90)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(.white))
    }
}
