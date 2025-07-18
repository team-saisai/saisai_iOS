//
//  RecentCourseView.swift
//  SaiSai
//
//  Created by 이창현 on 7/13/25.
//

import SwiftUI

struct RecentCourseView: View {
    
    @ObservedObject var vm: HomeViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("최근 코스")
                        .font(.pretendard(size: 12))
                        .foregroundStyle(.gray40)
                    
                    Text("\(vm.recentRide?.courseName ?? "")")
                        .font(.pretendard(.semibold, size: 20))
                        .padding(.bottom, 34)
                        .foregroundStyle(.white)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(vm.recentRide?.recentRideAt.dottedDateText ?? "")")
                        .font(.pretendard(.regular, size: 12))
                        .foregroundStyle(.gray70)
                    
                    HStack(spacing: 3) {
                        Text("총거리 ")
                            .font(.pretendard(.regular, size: 14))
                            .foregroundStyle(.gray20)
                        
                        Text("\(String(format: "%.1f", vm.recentRide?.distance ?? 0.0))km")
                            .font(.pretendard(size: 14))
                            .foregroundStyle(Color.customLime)
                            .lineLimit(1)
                    }
                    
                    HStack(spacing: 3) {
                        Text("완주율 ")
                            .font(.pretendard(.regular, size: 14))
                            .foregroundStyle(.gray20)
                        
                        Text("\(vm.recentRide?.progressRate ?? 0)%")
                            .font(.pretendard(size: 14))
                            .foregroundStyle(Color.customLime)
                    }
                }
            }
            .padding(EdgeInsets(top: 18, leading: 15, bottom: 18, trailing: 0))
            .foregroundStyle(.white)
            
            ZStack {
                Image("icMapEx")
                    .resizable()
                    .frame(height: 170)
                    .frame(maxWidth: .infinity) // TODO: - 나중에 수정 확인
                VStack(alignment: .trailing) {
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        Spacer()
                        
                        RoundedButton(radius: 4,
                                      bgColor: .customPurple,
                                      text: (vm.isRecentRideDone ? "다시 도전하기" : "이어하기"),
                                      action: { print("임시 버튼 Output") })
                    }
                    
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 17.5, trailing: 12))
            }
        }
        .frame(height: 170)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 8).fill(.main))
    }
}
