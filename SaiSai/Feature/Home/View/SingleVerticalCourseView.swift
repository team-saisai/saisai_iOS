//
//  SingleVerticalCourseView.swift
//  SaiSai
//
//  Created by 이창현 on 7/13/25.
//

import SwiftUI
import Kingfisher

struct SingleVerticalCourseView: View {
    
    let index: Int
    @ObservedObject var vm: HomeViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                
                KFImage(URL(string: vm.popularChallenges[index].imageUrl ?? ""))
                    .resizable()
                    .placeholder({
                        Image(systemName: "photo")
                            .foregroundStyle(.gray50)
                    })
                    .frame(height: 160)
                    .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("\(vm.popularChallenges[index].courseName)")
                            .font(.pretendard(.medium, size: 16))
                            .lineLimit(1)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 4)
                        Spacer()
                        Button {
                            vm.requestBookmark(
                                courseId: vm.popularChallenges[index].courseId,
                                index: index,
                                pastValue: vm.popularChallenges[index].isBookmarked
                            )
                        } label: {
                            Image(systemName: vm.popularChallenges[index].isBookmarked ? "bookmark.fill" : "bookmark")
                                .resizable()
                                .frame(width: 10.5, height: 13.5)
                        }
                    }
                    .foregroundStyle(.white)
                    
                    HStack(spacing: 5) {
                        Text("\(String(format:"%.1f", vm.popularChallenges[index].distance))km")
                        Text("·")
                        LevelView(level: vm.popularChallenges[index].level)
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
                    if let status = vm.popularChallenges[index].challengeStatusCase {
                        CourseTitleChip(challengeStatus: status,
                                        endedAt: vm.popularChallenges[index].challengeEndedAt)
                    }
                    if let isEventActive = vm.popularChallenges[index].isEventActive, isEventActive {
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
                Image(systemName: "figure.stand")
                    .resizable()
                    .frame(width: 10, height: 14)
                    .foregroundStyle(.customLightPurple)
                Text("\(vm.popularChallenges[index].participantsCount ?? 0)명")
            }
            if let reward = vm.popularChallenges[index].reward {
                HStack(spacing: 2) {
                    Image(.icStarIcon)
                        .frame(width: 12.5, height: 12)
                    Text("\(reward.commaDecimal)p")
                }
            }
        }
        .font(.pretendard(.regular, size: 12))
        .foregroundStyle(.iconPurple)
        .padding(.bottom, 14)
    }
}
