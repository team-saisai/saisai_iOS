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
        Button {
            print("\(contentInfo.courseId) CLICKED!")
        } label: {
            ZStack {
                HStack(spacing: 0) {
                    Image("icMapEx") /// ImageUrl 로 수정 필요
                        .resizable()
                        .scaledToFit()
                        .frame(width: 168)
                        .frame(maxHeight: .infinity)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(contentInfo.courseName)")
                            .foregroundStyle(.white)
                            .font(.pretendard(.medium, size: 16))
                            .padding(.bottom, 4)
                        
                        HStack(spacing: 5) {
                            Text("\(String(format:"%.1f", contentInfo.distance))km")
                            Text("·")
                            LevelView()
                        }
                        .padding(.bottom, 10)
                        .font(.pretendard(.medium, size: 12))
                        .foregroundStyle(.gray40)
                        
                        // TODO: - 테마 추가되면 테마로 변경
                        HStack {
                            CustomRoundedRectangle(radius: 4,
                                          bgColor: .gray80,
                                          text: "테마1",
                                          font: .pretendard(.regular, size: 12))
                        }
                        .padding(.bottom, 20)
                        
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
}

extension SingleHorizontalCourseView {
    
    private func LevelView() -> some View {
        HStack(spacing: 2) {
            Text("난이도 ")
            switch contentInfo.level {
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
                Text("\(contentInfo.courseChallengerCount)명")
            }
            HStack(spacing: 2) {
                Image("starIcon")
                    .frame(width: 12.5, height: 12)
                Text("\(contentInfo.reward.commaDecimal)p")
            }
        }
        .font(.pretendard(.regular, size: 12))
        .foregroundStyle(.iconPurple)
        .padding(.bottom, 14)
    }
}
