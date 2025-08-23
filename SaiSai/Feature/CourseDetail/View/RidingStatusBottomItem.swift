//
//  RidingStatusBottomItem.swift
//  SaiSai
//
//  Created by 이창현 on 7/25/25.
//

import SwiftUI

struct RidingStatusBottomItem: View {
    
    @ObservedObject var vm: CourseDetailViewModel
    private let buttonImage: [some View]  = [
        Image(systemName: "pause")
            .frame(width: 12.5, height: 14.1)
        ,
        Image(systemName: "play.fill")
            .frame(width: 11.4, height: 13.8)
    ]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    if vm.isPaused {
                        HStack(spacing: 4) {
                            Image(systemName: "pause")
                                .resizable()
                                .frame(width: 6.5, height: 9.8)
                            
                            Text("일시정지 중")
                                .font(.pretendard(size: 12))
                        }
                        .foregroundStyle(.titleChipRed)
                        .background(RoundedRectangle(cornerRadius: 50).fill(.pauseBgRed))
                    } else {
                        Text("체크포인트 달성률")
                            .font(.pretendard(.medium, size: 10))
                            .foregroundStyle(.gray40)
                        
                        HStack(spacing: 5) {
                            Text("\(Int(vm.numOfPassedCheckpoints / vm.numOfTotalCheckpoints * 100))%")
                                .font(.pretendard(.medium, size: 22))
                                .foregroundStyle(.customLime)
                            
                            Text("\(vm.numOfPassedCheckpoints)/\(vm.numOfTotalCheckpoints) points")
                                .font(.pretendard(size: 12))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding(.bottom, 11)
            }
            
            
            
            Button {
                vm.requestToggleIsPaused()
            } label: {
                VStack(spacing: 6.6) {
                    buttonImage[vm.isPaused ? 0 : 1]
                    
                    Text(vm.isPaused ? "이어하기" : "일시정지")
                        .font(.pretendard(.semibold, size: 12))
                }
                .foregroundStyle(.black)
                .padding(.horizontal, 6)
                .frame(width: 54, height: 62)
                .background(RoundedRectangle(cornerRadius: 14).fill(.customLime))
            }
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
        .background(RoundedRectangle(cornerRadius: 16).fill(.courseDetailBg))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(vm.isPaused ? .titleChipRed : .white, lineWidth: 1)
        }
    }
}

extension RidingStatusBottomItem {
    @ViewBuilder
    private func RidingStatusBar() -> some View {
        
    }
}
