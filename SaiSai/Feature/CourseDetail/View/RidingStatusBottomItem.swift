//
//  RidingStatusBottomItem.swift
//  SaiSai
//
//  Created by 이창현 on 7/25/25.
//

import SwiftUI

struct RidingStatusBottomItem: View {
    
    @ObservedObject var vm: CourseDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            VStack {
                HStack(spacing: 4) {
                    Text("\(String(format: "%.1f", vm.currentDistance))km")
                        .font(.pretendard(.medium, size: 24))
                        .foregroundStyle(.customLime)
                    Text("/")
                    Text("\(String(format: "%.1f", vm.totalDistance))km")
                    Spacer()
                }
                .font(.pretendard(.regular, size: 24))
                .foregroundStyle(.white)
                
                ProgressView(value: vm.progressPercentage)
                    .tint(.customLime)
            }
            
            HStack(spacing: 4) {
                Image(.checkpointIcon)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 7, height: 12)
                Text("다음 체크포인트: ")
                Text("256m") // 임시 Value
                    .foregroundStyle(.customLime)
                Spacer()
                Image(systemName: "line.3.horizontal")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 17, height: 13)
                // 나중에 버튼 추가 예정
            }
            .font(.pretendard(.medium, size: 14))
            .foregroundStyle(.white)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
        .background(RoundedRectangle(cornerRadius: 16).fill(.courseDetailBg))
    }
}
