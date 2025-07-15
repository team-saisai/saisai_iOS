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
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                
                Image("icMapEx") /// ImageUrl 로 수정 필요
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(courseInfo.courseName)")
                        .foregroundStyle(.white)
                        .font(.pretendard(.medium, size: 16))
                        .padding(.bottom, 4)
                    
                    HStack(spacing: 5) {
                        Text("\(String(format:"%.1f", courseInfo.distance))km")
                        Text("·")
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
            
            // MARK: - Title Chip
            VStack(spacing: 0) {
                HStack(spacing: 4) {
                    CourseTitleChip(challengeStatus: courseInfo.challengeStatusCase,
                                    endedAt: courseInfo.endedAt)
                    if courseInfo.isEventActive {
                        CourseTitleChip(isEvent: true, challengeStatus: .ended, endedAt: "")
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding(.all, 6)
        }
        .background(.main)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
