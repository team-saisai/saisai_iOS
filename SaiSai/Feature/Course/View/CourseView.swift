//
//  CourseView.swift
//  SaiSai
//
//  Created by 이창현 on 7/11/25.
//

import SwiftUI

struct CourseView: View {
    
    @State var isMenuFolded: Bool = true
    @StateObject var vm: CourseViewModel = .init()
    @EnvironmentObject var tabState: TabState
    
    var body: some View {
        ZStack {
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
                                    .environmentObject(tabState)
                                } label: {
                                    HStack {
                                        SingleHorizontalCourseView(
                                            index: index,
                                            vm: vm
                                        )
                                    }
                                    .padding(.bottom, 20)
                                }
                                
                            }
                        } else {
                            EmptyCourseListView(messageText: "코스가 없습니다.",
                                                buttonVisibility: false,
                                                bikeVisibility: true
                            )
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
            
            if !isMenuFolded {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isMenuFolded = true
                        }
                    }
            }
            
            VStack {
                HStack {
                    Spacer()
                    CustomDropDown(
                        isFolded: $isMenuFolded,
                        optionPublisher: vm.optionPublisher,
                        tappedOutsidePublisher: vm.tappedoutsidePublisher
                    )
                }
                .padding(.horizontal, 18)
                Spacer()
            }
            .padding(.top, 63)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .zIndex(1)
            
            if vm.isRequestingBookmarks {
                VStack {
                    ProgressView()
                        .opacity(0.7)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.gray5.opacity(0.05))
            }
        }
        .onReceive(vm.optionPublisher) { option in
            vm.setSortOption(option)
        }
    }
}

extension CourseView {
    @ViewBuilder
    private func ChallengeFilter() -> some View {
        let options: [String] = ["챌린지", "일반 코스"]
        let highlightedColor: Color = .customPurple
        let defaultColor: Color = .gray80
        
        ZStack {
            HStack(spacing: 0) {
                ForEach(options.indices, id: \.self) { idx in
                    Button {
                        vm.setOnlyOngoing(idx == 0 ? true : false)
                    } label: {
                        HStack(spacing: 4) {
                            if idx == 0 {
                                Image(.icFireIcon)
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 13.8, height: 15.4)
                            }
                            Text(options[idx])
                        }
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(.white)
                        .padding(.vertical, 8.5)
                        .padding(.leading, idx == 0 ? 14 : 22)
                        .padding(.trailing, 22)
                        .background(RoundedRectangle(cornerRadius: 50)
                            .fill((
                                idx == 0 && vm.isChallengeSelected ||
                                idx == 1 && !vm.isChallengeSelected) ?
                                  highlightedColor : .clear))
                    }
                }
            }
            .background(RoundedRectangle(cornerRadius: 50).fill(defaultColor))
        }
    }
}
