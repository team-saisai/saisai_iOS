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
        Image(systemName: "pause.fill")
            .frame(width: 12.5, height: 14.1)
        ,
        Image(systemName: "play.fill")
            .frame(width: 11.4, height: 13.8)
    ]
    
    var body: some View {
        HStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    if vm.isPaused {
                        HStack {
                            HStack(spacing: 8) {
                                Image(systemName: "pause.fill")
                                    .resizable()
                                    .frame(width: 6.5, height: 9.8)
                                
                                Text("일시정지 중")
                                    .font(.pretendard(size: 12))
                                
                            }
                            .foregroundStyle(.titleChipRed)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(RoundedRectangle(cornerRadius: 50).fill(.pauseBgRed))
                            
                            Spacer()
                        }
                        .padding(.bottom, 20)
                    } else {
                        HStack {
                            Text("체크포인트 달성률")
                                .font(.pretendard(.medium, size: 10))
                                .foregroundStyle(.gray40)
                            Spacer()
                        }
                        
                        HStack(spacing: 5) {
                            Text("\(vm.checkpointPercentage)%")
                                .font(.pretendard(.medium, size: 22))
                                .foregroundStyle(.customLime)
                            
                            Text("\(vm.numOfPassedCheckpoints)/\(vm.numOfTotalCheckpoints) points")
                                .font(.pretendard(size: 12))
                                .foregroundStyle(.white)
                            
                            Spacer()
                        }
                        .padding(.bottom, 11)
                    }
                }

                CheckpointStatusBar()
            }
            .frame(maxWidth: .infinity)
            
            
            Button {
                vm.requestToggleIsPaused()
            } label: {
                VStack(spacing: 6.6) {
                    buttonImage[vm.isPaused ? 1 : 0]
                    
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
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 16).fill(.courseDetailBg))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(vm.isPaused ? .titleChipRed : .white, lineWidth: 1)
        }
    }
}

extension RidingStatusBottomItem {
    @ViewBuilder
    private func CheckpointStatusBar() -> some View {
        VStack(spacing: 4) {
            ProgressView(value: Double(vm.numOfPassedCheckpoints / vm.numOfTotalCheckpoints))
                .tint(.customLime)
                .overlay {
                    HStack {
                        Circle().fill(.customLime)
                            .frame(width: 13, height: 13)
                        
                        Spacer()
                        
                        Circle().fill(.customLime)
                            .frame(width: 13, height: 13)
                    }
                }
            HStack {
                Text("GO")
                Spacer()
                Text("FIN")
            }
            .font(.pretendard(.medium, size: 10))
            .foregroundStyle(.white)
        }
    }
}
