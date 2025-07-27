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
                
                Image(.icMapEx) /// ImageUrl 로 수정 필요
                    .resizable()
                    .frame(height: 160)
                    .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("\(courseInfo.courseName)")
                            .foregroundStyle(.white)
                            .font(.pretendard(.medium, size: 16))
                            .padding(.bottom, 4)
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "bookmark") // TODO: - API 추가되면 이 바인딩 필요
                                .resizable()
                                .frame(width: 10.5, height: 13.5)
                        }
                    }
                    
                    HStack(spacing: 5) {
                        Text("\(String(format:"%.1f", courseInfo.distance))km")
                        Text("·")
                        LevelView(level: courseInfo.level)
                    }
                    .padding(.bottom, 10)
                    .font(.pretendard(.medium, size: 12))
                    .foregroundStyle(.gray40)
                    
                    FooterView()
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
        .frame(width: 200)
    }
}

// MARK: - FooterView
extension SingleVerticalCourseView {
    
    private func FooterView() -> some View {
        HStack(spacing: 8) {
            HStack(spacing: 2) {
                Image(.icThunderIcon)
                    .resizable()
                    .frame(width: 10, height: 14)
                Text("\(courseInfo.challengerCount)명")
            }
            if courseInfo.reward != 0 {
                HStack(spacing: 2) {
                    Image(.icStarIcon)
                        .frame(width: 12.5, height: 12)
                    Text("\(courseInfo.reward.commaDecimal)p")
                }
            }
        }
        .font(.pretendard(.regular, size: 12))
        .foregroundStyle(.iconPurple)
        .padding(.bottom, 14)
    }
}
