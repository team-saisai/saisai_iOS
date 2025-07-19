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
            
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(spacing: 0) {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 8) {
                            ChallengeFilter()
                            // TODO: - ForEach(theme) 추가 예정
                            
                            RoundedButton(radius: 6, bgColor: .gray80, horizontalPadding: 14, verticalPadding: 8.5, text: "테마1", font: .pretendard(size: 14), action: {})
                            RoundedButton(radius: 6, bgColor: .gray80, horizontalPadding: 14, verticalPadding: 8.5, text: "테마2", font: .pretendard(size: 14), action: {})
                            RoundedButton(radius: 6, bgColor: .gray80, horizontalPadding: 14, verticalPadding: 8.5, text: "테마3", font: .pretendard(size: 14), action: {})
                            RoundedButton(radius: 6, bgColor: .gray80, horizontalPadding: 14, verticalPadding: 8.5, text: "테마4", font: .pretendard(size: 14), action: {})
                            RoundedButton(radius: 6, bgColor: .gray80, horizontalPadding: 14, verticalPadding: 8.5, text: "테마5", font: .pretendard(size: 14), action: {})
                            RoundedButton(radius: 6, bgColor: .gray80, horizontalPadding: 14, verticalPadding: 8.5, text: "테마6", font: .pretendard(size: 14), action: {})
                        }
                        .padding(.bottom, 24)
                        .frame(maxWidth: .infinity)
                    }
                    
                    if !vm.contentInfoList.isEmpty {
                        ForEach(vm.contentInfoList.indices, id: \.self) { index in
                            HStack {
                                SingleHorizontalCourseView(contentInfo: vm.contentInfoList[index])
                            }
                            .padding(.bottom, 20)
                        }
                    }
                    
                    if vm.hasReachedLast {
                        ProgressView()
                            .onAppear() {
                                vm.fetchData()
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
    private func ChallengeFilter() -> some View {
        RoundedButton(radius: 6, bgColor: .gray90, horizontalPadding: 14, verticalPadding: 8.5, text: "챌린지 중", font: .pretendard(size: 14), hasFireImage: true, action: {})
            .border(Color.red, width: 1)
            .foregroundStyle(.red)
    }
}
