//
//  SingleHorizontalCourseView.swift
//  SaiSai
//
//  Created by 이창현 on 7/18/25.
//

import SwiftUI

struct SingleHorizontalCourseView: View {
    
    let contentInfo: CourseContentInfo
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Image(.icMapEx) /// ImageUrl 로 수정 필요
                    .resizable()
                    .frame(width: 168)
                    .frame(maxHeight: .infinity)
                    .overlay {
                        LinearGradient(gradient: .init(colors: [.clear, .main]),
                                       startPoint: .center, endPoint: .trailing)
                    }
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("\(contentInfo.courseName)")
                            .font(.pretendard(.medium, size: 16))
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "bookmark") // TODO: - API 추가되면 이 바인딩 필요
                                .resizable()
                                .frame(width: 10.5, height: 13.5)
                        }
                    }
                    .foregroundStyle(.white)
                    .padding(.bottom, 4)
                    .padding(.trailing, 14)
                    
                    HStack(spacing: 5) {
                        Text("\(String(format:"%.1f", contentInfo.distance))km")
                        Text("·")
                        LevelView(level: contentInfo.level)
                    }
                    .padding(.bottom, 44)
                    .font(.pretendard(.medium, size: 12))
                    .foregroundStyle(.gray40)
                    
                    FooterView()
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 18)
                
                Spacer()
            }
            
            // MARK: - Title Chip
            VStack(spacing: 0) {
                HStack(spacing: 4) {
                    CourseTitleChip(challengeStatus: contentInfo.challengeStatusCase,
                                    endedAt: contentInfo.challengeEndedAt)
                    if contentInfo.isEventActive {
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
        .frame(height: 144)
    }
}

extension SingleHorizontalCourseView {
    
    private func FooterView() -> some View {
        HStack(spacing: 8) {
            HStack(spacing: 2) {
                Image(.icThunderIcon)
                    .resizable()
                    .frame(width: 10, height: 14)
                Text("\(contentInfo.courseChallengerCount.commaDecimal)명 도전중")
            }
            if contentInfo.reward != 0 {
                HStack(spacing: 2) {
                    Image(.icStarIcon)
                        .frame(width: 12.5, height: 12)
                    Text("\(contentInfo.reward.commaDecimal)p")
                }
            }
        }
        .font(.pretendard(.regular, size: 12))
        .foregroundStyle(.iconPurple)
    }
}
