//
//  CourseView.swift
//  SaiSai
//
//  Created by 이창현 on 7/11/25.
//

import SwiftUI

struct CourseView: View {
    
    @StateObject var vm: CourseViewModel = .init()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("코스")
                    .font(.pretendard(.semibold, size: 20))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.vertical, 18)
            .padding(.leading, 24)
            
            HStack {
                ChallengeFilter()
                Spacer()
                // TODO: - 드롭다운 추가
            }
            .padding(.bottom, 24)
            .padding(.horizontal, 20)
            
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack {
                    if !vm.contentInfoList.isEmpty {
                        ForEach(vm.contentInfoList.indices, id: \.self) { index in
                            NavigationLink {
                                CourseDetailView(
                                    vm: CourseDetailViewModel(
                                        courseId: vm.contentInfoList[index].courseId))
                            } label: {
                                HStack {
                                    SingleHorizontalCourseView(contentInfo: vm.contentInfoList[index])
                                }
                                .padding(.bottom, 20)
                            }
                            
                        }
                    }
                    
                    if vm.hasReachedSinglePageLast {
                        ProgressView()
                            .onAppear() {
                                vm.fetchData()
                                print("Reached ProgressView!")
                            }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .background(.gray90)
    }
}

extension CourseView {
    @ViewBuilder
    private func ChallengeFilter() -> some View {
        let options: [String] = ["챌린지", "일반 코스"]
        let highlightedColor: Color = .customPurple
        let defaultColor: Color = .gray80
        
        HStack(spacing: 0) {
            ZStack {
                
            }
            
            ForEach(options.indices, id: \.self) { idx in
                ZStack {
                    Rectangle()
                        .foregroundStyle(defaultColor)
                    Rectangle()
                        .padding(
                            EdgeInsets(
                                top: 8.5,
                                leading: idx == 0 ? 18.4 : 22,
                                bottom: 8.5,
                                trailing: 22))
                        .cornerRadius(50)
                        .opacity((idx == 0 && vm.isOnlyOngoing || idx == 1 && !vm.isOnlyOngoing) ? 1 : 0)
                        .onTapGesture {
                            withAnimation(.interactiveSpring()) {
                                vm.setOnlyOngoing(idx == 0 ? true : false)
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 50).fill(highlightedColor))
                }
                .overlay {
                    HStack(spacing: 8) {
                        if idx == 0 {
                            Image(.icFireIcon)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(.white)
                                .frame(width: 13.8, height: 15.4)
                        }
                        
                        Text(options[idx])
                            .font(.pretendard(size: 14))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .frame(height: 34)
        .cornerRadius(50)
    }
}
