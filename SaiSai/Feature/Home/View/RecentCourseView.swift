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
                    Text("여의서로 - 여의대로")
                        .font(.pretendard(.semibold, size: 20))
                        .padding(.bottom, 34)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("2024.06.10")
                        .font(.pretendard(.regular, size: 12))
                        .foregroundStyle(.gray70)
                    HStack(spacing: 12) {
                        Text("총거리 5.8km")
                        Text("완주율 100%")
                    }
                }
            }
            .foregroundStyle(.white)
            Spacer()
            VStack(spacing: 0) {
                Spacer()
                Button(action: {
                    // TODO: - 다시 도전하기 기능구현
                    print("다시 도전하기 클릭")
                }, label: {
                    Text("다시 도전하기")
                        .foregroundStyle(.white)
                        .font(.pretendard(.medium, size: 12))
                })
                .padding(.horizontal, 9)
                .padding(.vertical, 6)
                .background(RoundedRectangle(cornerRadius: 4).fill(Color(red: 87 / 255, green: 59 / 255, blue: 245 / 255)))
            }
        }
        .padding(.all, 18)
        .background(RoundedRectangle(cornerRadius: 8).fill(.gray100.opacity(0.04)))
    }
}
