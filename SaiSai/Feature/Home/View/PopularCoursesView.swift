//
//  PopuluarCoursesView.swift
//  SaiSai
//
//  Created by 이창현 on 7/13/25.
//

import SwiftUI

struct PopularCoursesView: View {
    
    @ObservedObject var vm: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("인기 챌린지")
                    .foregroundStyle(.white)
                    .font(.pretendard(.semibold, size: 18))
                Spacer()
            }
            .padding(.bottom, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(vm.popularCourses.indices, id: \.self) {
                        SingleVerticalCourseView(courseInfo: vm.popularCourses[$0])
                    }
                }
            }
        }
    }
}
