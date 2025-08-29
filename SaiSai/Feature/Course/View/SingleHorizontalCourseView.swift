//
//  SingleHorizontalCourseView.swift
//  SaiSai
//
//  Created by 이창현 on 7/18/25.
//

import SwiftUI
import Kingfisher

struct SingleHorizontalCourseView: View {
    
    let index: Int
    @ObservedObject var vm: CourseViewModel
    
    var body: some View {
        if vm.contentInfoList.count > index {
            ZStack {
                HStack(spacing: 0) {
                    KFImage(URL(string: vm.contentInfoList[index].imageUrl ?? ""))
                        .resizable()
                        .placeholder({
                            Image(systemName: "photo")
                                .foregroundStyle(.gray50)
                        })
                        .frame(width: 168)
                        .frame(maxHeight: .infinity)
                        .overlay {
                            LinearGradient(gradient: .init(colors: [.clear, .main]),
                                           startPoint: .center, endPoint: .trailing)
                        }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("\(vm.contentInfoList[index].courseName)")
                                .font(.pretendard(.medium, size: 16))
                                .lineLimit(1)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Button {
                                vm.requestBookmark(
                                    courseId: vm.contentInfoList[index].courseId,
                                    index: index,
                                    pastValue: vm.contentInfoList[index].isBookmarked
                                )
                            } label: {
                                Image(systemName: vm.contentInfoList[index].isBookmarked ? "bookmark.fill" : "bookmark")
                                    .resizable()
                                    .frame(width: 10.5, height: 13.5)
                            }
                        }
                        .foregroundStyle(.white)
                        .padding(.bottom, 4)
                        .padding(.trailing, 14)
                        
                        HStack(spacing: 5) {
                            Text("\(String(format:"%.1f", vm.contentInfoList[index].distance))km")
                            Text("·")
                            LevelView(level: vm.contentInfoList[index].level)
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
                        if let status = vm.contentInfoList[index].challengeStatusCase {
                            CourseTitleChip(
                                challengeStatus: status,
                                endedAt: vm.contentInfoList[index].challengeEndedAt
                            )
                        }
                        if let isEventActive = vm.contentInfoList[index].isEventActive, isEventActive {
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
    
    private func FooterView() -> some View {
        HStack(spacing: 8) {
            HStack(spacing: 2) {
                if let participantsCount = vm.contentInfoList[index].participantsCount {
                    Image(.icThunderIcon)
                        .resizable()
                        .frame(width: 10, height: 14)
                    Text("\(participantsCount.commaDecimal)명 도전중")
                }
            }
            if let reward = vm.contentInfoList[index].reward {
                HStack(spacing: 2) {
                    Image(.icStarIcon)
                        .frame(width: 12.5, height: 12)
                    Text("\(reward.commaDecimal)p")
                }
            }
        }
        .font(.pretendard(.regular, size: 12))
        .foregroundStyle(.iconPurple)
    }
}
