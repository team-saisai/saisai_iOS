//
//  SingleSavedCourseView.swift
//  SaiSai
//
//  Created by ch on 8/17/25.
//

import SwiftUI
import Combine

struct SingleSavedCourseView: View {
    
    let index: Int
    @ObservedObject var vm: SavedCoursesViewModel
    let isEditingPublisher: PassthroughSubject<Bool, Never>
    
    var body: some View {
        if vm.contentInfoList.count > index {
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
                            Text("\(vm.contentInfoList[index].courseName)")
                                .font(.pretendard(.medium, size: 16))
                            Spacer()
                            if !vm.isEditing {
                                Button {
                                    vm.requestSingleBookmark(
                                        courseId: vm.contentInfoList[index].courseId,
                                        index: index
                                    )
                                } label: {
                                    Image(systemName: vm.contentInfoList[index].isBookmarked ? "bookmark.fill" : "bookmark")
                                        .resizable()
                                        .frame(width: 10.5, height: 13.5)
                                }
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
                                endedAt: vm.contentInfoList[index].challengeEndedAt,
                                isEditingPublisher: isEditingPublisher
                            )
                            .background(vm.isEditing ? .gray60 : .clear)
                        }
                        if let isEventActive = vm.contentInfoList[index].isEventActive, isEventActive {
                            CourseTitleChip(isEvent: true,
                                            challengeStatus: .ended,
                                            endedAt: "",
                                            isEditingPublisher: isEditingPublisher
                            )
                            .background(vm.isEditing ? .gray60 : .clear)
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

extension SingleSavedCourseView {
    
    private func FooterView() -> some View {
        HStack(spacing: 8) {
            HStack(spacing: 2) {
                if let participantsCount = vm.contentInfoList[index].participantsCount, participantsCount != 0 {
                    Image(.icThunderIcon)
                        .resizable()
                        .frame(width: 10, height: 14)
                    Text("\(participantsCount.commaDecimal)명 도전중")
                }
            }
            if let reward = vm.contentInfoList[index].reward, reward != 0 {
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

