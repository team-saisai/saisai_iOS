//
//  CourseDetailBottomItem.swift
//  SaiSai
//
//  Created by 이창현 on 7/20/25.
//

import SwiftUI

struct CourseDetailBottomItem: View {
    
    @ObservedObject var vm: CourseDetailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                CourseDetailSummaryView()
                
                Spacer()
                
                VStack(spacing: 6) {
                    Button {
                        
                    } label: {
                        VStack(spacing: 6.5) {
                            Image(.icBicycle)
                                .resizable()
                                .frame(width: 16.4, height: 15.2)
                            
                            Text("도전하기")
                                .font(.pretendard(.semibold, size: 12))
                                .foregroundStyle(.gray90)
                        }
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color.customLime))
                    }
                    
                    Text("1h 30m")
                        .font(.pretendard(size: 12))
                        .foregroundStyle(.customLime)
                }
            }
        }
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.courseDetailBg))
        .padding(.vertical, 20)
        .padding(.horizontal, 22)
    }
}

extension CourseDetailBottomItem {
    private func CourseDetailSummaryView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(vm.courseDetail?.courseName ?? "")
                .font(.pretendard(size: 20))
                .foregroundStyle(.white)
                .padding(.bottom, 6)
            
            HStack(spacing: 5) {
                Text("\(String(format: "%1f", vm.courseDetail?.distance ?? 0.0))km")
                Text("·")
                LevelView(level: vm.courseDetail?.level ?? 0)
            }
            .padding(.bottom, 8)
            
            
        }
    }
}
