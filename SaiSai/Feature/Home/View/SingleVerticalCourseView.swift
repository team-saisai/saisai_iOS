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
                    .resizable()
                    .scaledToFit()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(courseInfo.courseName)")
                        .foregroundStyle(.white)
                        .font(.pretendard(.medium, size: 16))
                        .padding(.bottom, 4)
                    
                    HStack(spacing: 5) {
                        Text("\(String(format:"%.1f", courseInfo.distance))km")
                        Text("·")
                        LevelView()
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
    }
}

// MARK: - LevelView, FooterView
extension SingleVerticalCourseView {
    
    private func LevelView() -> some View {
        HStack(spacing: 2) {
            Text("난이도 ")
            switch courseInfo.level {
            case 1:
                Text("하")
                    .foregroundStyle(.levelLow)
            case 2:
                Text("중")
                    .foregroundStyle(.levelMiddle)
            case 3:
                Text("상")
                    .foregroundStyle(.levelHigh)
            default:
                Text("")
            }
        }
    }
    
    private func FooterView() -> some View {
        HStack(spacing: 8) {
            HStack(spacing: 2) {
                Image("thunderIcon")
                    .resizable()
                    .frame(width: 10, height: 14)
                Text("\(courseInfo.challengerCount)명")
            }
            HStack(spacing: 2) {
                Image("starIcon")
                    .frame(width: 12.5, height: 12)
                Text("\(courseInfo.reward.commaDecimal)p")
            }
        }
        .font(.pretendard(.regular, size: 12))
        .foregroundStyle(.iconPurple)
        .padding(.bottom, 14)
    }
}
