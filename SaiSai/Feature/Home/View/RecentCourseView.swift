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
                    Text("최근 챌린지")
                        .font(.pretendard(size: 12))
                        .foregroundStyle(.gray40)
                    
                    Text("\(vm.recentRide?.courseName ?? "")")
                        .font(.pretendard(.semibold, size: 20))
                        .padding(.bottom, 34)
                        .foregroundStyle(.white)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(vm.recentRide?.recentRideAt ?? "")")
                        .font(.pretendard(.regular, size: 12))
                        .foregroundStyle(.gray70)
                    
                    HStack(spacing: 12) {
                        Text("총거리 \(String(format: "%.1f", vm.recentRide?.distance ?? 0.0))km")
                        
                        Text("완주율 \(vm.recentRide?.progressRate ?? 0)%")
                    }
                }
            }
            .padding(.all, 18)
            .foregroundStyle(.white)
            
            ZStack {
                Image("icMapEx")
                VStack(alignment: .trailing) {
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        Spacer()
                        
                        RoundedButton(radius: 4,
                                      bgColor: .customPurple,
                                      text: (vm.isRecentRideDone ? "다시하기" : "이어하기"),
                                      action: { print("임시 버튼 Output") })
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 17.5, trailing: 12))
            }
        }
        .background(RoundedRectangle(cornerRadius: 8).fill(.main))
        .frame(maxWidth: .infinity)
    }
}
