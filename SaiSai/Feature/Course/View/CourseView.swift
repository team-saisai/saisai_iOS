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
        ScrollView {
            LazyVStack {
                HStack {
                    Text("코스")
                        .font(.pretendard(.semibold, size: 20))
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.bottom, 17)
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 8) {
                        RoundedButton(radius: 6, bgColor: .gray90, horizontalPadding: 14, verticalPadding: 8.5, text: "챌린지 중", font: .pretendard(size: 14), hasFireImage: true, action: {})
                        RoundedButton(radius: 6, bgColor: .gray80, horizontalPadding: 14, verticalPadding: 8.5, text: "테마1", font: .pretendard(size: 14), action: {})
                        RoundedButton(radius: 6, bgColor: .gray80, horizontalPadding: 14, verticalPadding: 8.5, text: "테마2", font: .pretendard(size: 14), action: {})
                        RoundedButton(radius: 6, bgColor: .gray80, horizontalPadding: 14, verticalPadding: 8.5, text: "테마3", font: .pretendard(size: 14), action: {})
                        RoundedButton(radius: 6, bgColor: .gray80, horizontalPadding: 14, verticalPadding: 8.5, text: "테마4", font: .pretendard(size: 14), action: {})
                        RoundedButton(radius: 6, bgColor: .gray80, horizontalPadding: 14, verticalPadding: 8.5, text: "테마5", font: .pretendard(size: 14), action: {})
                        RoundedButton(radius: 6, bgColor: .gray80, horizontalPadding: 14, verticalPadding: 8.5, text: "테마6", font: .pretendard(size: 14), action: {})
                    }
                    .padding(.bottom, 24)
                    .frame(maxWidth: .infinity)
                    .scrollIndicators(.hidden)
                }
                
                Spacer(minLength: 10)
                
                if !vm.contentInfoList.isEmpty {
                    SingleHorizontalCourseView(contentInfo: vm.contentInfoList[0])
                }
            }
        }
        .padding(.vertical, 22)
        .padding(.horizontal, 20)
        .background(.gray90)
        .onAppear() {
            vm.fetchData()
        }
    }
}

#Preview {
    CourseView()
}
