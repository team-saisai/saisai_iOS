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
            }
            .padding(.bottom, 24)
            .padding(.leading, 22)
            
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
    
    private enum FilterMetric {
        static let verticalPadding = 8.5
        static let challengeLeadingPadding = 10.5
        static let challengeTrailingPadding = 12.0
        static let themeFilterHorizontalPadding = 14.0
        static let radius = 6.0
    }
    
    private func ChallengeFilter() -> some View {
        Filter(isChallengeFilter: true, text: "챌린지 중", action: { vm.challengeButtonClicked() })
            .foregroundStyle(vm.isOnlyOngoing ? .titleChipRed : .white)
            .background(vm.isOnlyOngoing ? .gray80 : .gray90)
            .overlay {
                RoundedRectangle(cornerRadius: FilterMetric.radius)
                    .stroke(vm.isOnlyOngoing ? .titleChipRed : .white , lineWidth: 1.5)
            }
    }
    
    private func Filter(isChallengeFilter: Bool,
                        text: String,
                        action: @escaping () -> Void) -> some View {
        Button(action: action,
               label: {
            HStack(spacing: 6) {
                if isChallengeFilter {
                    Image(.icFireIcon)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 13.8, height: 15.4)
                }
                Text(text)
                    .font(.pretendard(size: 14))
            }
            .padding(.vertical, FilterMetric.verticalPadding)
            .padding(.leading,
                     isChallengeFilter ?
                     FilterMetric.challengeLeadingPadding :
                        FilterMetric.themeFilterHorizontalPadding)
            .padding(.trailing,
                     isChallengeFilter ?
                     FilterMetric.challengeTrailingPadding :
                        FilterMetric.themeFilterHorizontalPadding)
        })
    }
}
