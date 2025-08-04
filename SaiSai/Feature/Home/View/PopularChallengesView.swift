//
//  PopuluarChallengesView.swift
//  SaiSai
//
//  Created by 이창현 on 7/13/25.
//

import SwiftUI

struct PopularChallengesView: View {
    
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
                LazyHStack(spacing: 10) {
                    ForEach(vm.popularChallenges.indices, id: \.self) { idx in
                        NavigationLink {
                            CourseDetailView(vm: CourseDetailViewModel(courseId: vm.popularChallenges[idx].courseId))
                        } label: {
                            SingleVerticalCourseView(index: idx, vm: vm)
                        }

                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}
