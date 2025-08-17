//
//  SingleCourseHistoryView.swift
//  SaiSai
//
//  Created by ch on 8/17/25.
//

import SwiftUI
import Combine

struct SingleCourseHistoryView: View {
    
    let index: Int
    @ObservedObject var vm: CourseHistoryViewModel
    let isEditingPublisher: PassthroughSubject<Bool, Never>
    
    var body: some View {
        if vm.myRideInfoList.count > index {
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
                            Text("\(vm.myRideInfoList[index].courseName)")
                                .font(.pretendard(.medium, size: 16))
                            Spacer()
                        }
                        .foregroundStyle(.white)
                        .padding(.bottom, 4)
                        .padding(.trailing, 14)
                        
                        HStack(spacing: 5) {
                            Text("\(String(format:"%.1f", vm.myRideInfoList[index].distance))km")
                            Text("·")
                            LevelView(level: vm.myRideInfoList[index].level)
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
                        if let status = vm.myRideInfoList[index].challengeStatusCase {
                            CourseTitleChip(
                                challengeStatus: status,
                                endedAt: vm.myRideInfoList[index].challengeEndedAt,
                                isEditingPublisher: isEditingPublisher
                            )
                            .background(vm.isEditing ? .gray60 : .clear)
                        }
                        if let isEventActive = vm.myRideInfoList[index].isEventActive, isEventActive {
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

extension SingleCourseHistoryView {
    
    private func FooterView() -> some View {
        VStack(spacing: 3) {
            HStack {
                Text("\(String(vm.myRideInfoList[index].lastRideDate.prefix(10)).dottedDateText)")
                    .font(.pretendard(size: 11))
                    .foregroundStyle(.gray70)
                
                Spacer()
            }
            
            HStack(spacing: 4) {
                Text("\(String(format: "%.1f", vm.myRideInfoList[index].distance))km ")
                Text("·")
                Text("완주율")
                Text("\(vm.myRideInfoList[index].progressRate)%")
                    .font(.pretendard(.medium, size: 13))
                    .foregroundStyle(.customLime)
                Spacer()
            }
            .font(.pretendard(size: 13))
            .foregroundStyle(.white)
        }
    }
}

