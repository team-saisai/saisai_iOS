//
//  SingleVerticalCourseView.swift
//  SaiSai
//
//  Created by 이창현 on 7/13/25.
//

import SwiftUI

struct SingleVerticalCourseView: View {
    
    @State var courseInfo: CourseInfo
    
    var body: some View {
        // TODO: - 길 이름, 난이도, 도전인원등은 API 에서 데이터 받아서 보여줘야 함.
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                // TODO: - 이미지
                Image("icMapEx") /// ImageUrl 로 수정 필요
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(courseInfo.courseName)")
                        .foregroundStyle(.white)
                        .font(.pretendard(.medium, size: 16))
                        .padding(.bottom, 4)
                    
                    HStack(spacing: 0) {
                        Text("\(String(format:"%.1f", courseInfo.distance))km")
                        Text("난이도 \(courseInfo.level)") // 전환 메서드 필요
                    }
                    .padding(.bottom, 10)
                    .font(.pretendard(.medium, size: 12))
                    .foregroundStyle(.gray40)
                    
                    Text("\(courseInfo.challengerCount)명 도전중")
                        .font(.pretendard(.regular, size: 12))
                        .foregroundStyle(Color(red: 128 / 255, green: 105 / 255, blue: 253 / 255))
                        .padding(.bottom, 14)
                }
                .padding(.horizontal, 12)
                
            }
            .background(RoundedRectangle(cornerRadius: 8).fill(.black.opacity(0.04)))
            
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text("~\(courseInfo.endedAt)") // 전환 메서드 필요
                        .font(.pretendard(.medium, size: 12))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 6)
                        .background(RoundedRectangle(cornerRadius: 6).fill(Color(red: 222 / 255, green: 102 / 255, blue: 102 / 255)))
                        .padding(.leading, 5)
                        .padding(.top, 5)
                    
                    Spacer()
                }
                Spacer()
            }
            
        }
    }
}
