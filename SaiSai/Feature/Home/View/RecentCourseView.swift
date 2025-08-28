//
//  RecentCourseView.swift
//  SaiSai
//
//  Created by 이창현 on 7/13/25.
//

import SwiftUI
import Kingfisher

struct RecentCourseView: View {
    
    @ObservedObject var vm: HomeViewModel
    @EnvironmentObject var tabState: TabState
    
    var body: some View {
        NavigationLink {
            CourseDetailView(
                vm: CourseDetailViewModel(courseId: vm.recentRide?.courseId ?? 0))
            .environmentObject(tabState)
        } label: {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("최근 코스")
                            .font(.pretendard(size: 12))
                            .foregroundStyle(.gray40)
                        
                        Text("\(vm.recentRide?.courseName ?? "")")
                            .font(.pretendard(.semibold, size: 20))
                            .padding(.bottom, 34)
                            .foregroundStyle(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(vm.recentRide?.recentRideAt.dottedDateText ?? "")")
                            .font(.pretendard(.regular, size: 12))
                            .foregroundStyle(.gray70)
                        
                        HStack(spacing: 3) {
                            Text("\(String(format: "%.1f", vm.recentRide?.distance ?? 0.0))km")
                            
                            Text("·")
                            
                            Text("달성률 ")
                                .font(.pretendard(.regular, size: 14))
                            
                            Text("\(vm.recentRide?.progressRate ?? 0)%")
                                .foregroundStyle(.customLime)
                                .font(.pretendard(size: 13))
                        }
                        .foregroundStyle(.gray10)
                        .font(.pretendard(.regular, size: 13))
                    }
                }
                .padding(EdgeInsets(top: 18, leading: 15, bottom: 18, trailing: 0))
                .frame(height: 145)
                
                Spacer()
                
                ZStack {
                    KFImage(URL(string: vm.recentRide?.courseImageUrl ?? ""))
                        .resizable()
                        .placeholder({
                            Image(systemName: "photo")
                                .foregroundStyle(.gray50)
                        })
                    VStack(alignment: .trailing) {
                        Spacer()
                        
                        HStack(alignment: .bottom) {
                            Spacer()
                            
                            NavigationLink(
                                destination: CourseDetailView(
                                    vm: CourseDetailViewModel(
                                        courseId: vm.recentRide?.courseId ?? 0,
                                        isByContinueButton: !vm.isRecentRideDone
                                    )
                                ).environmentObject(tabState)) {
                                    CustomRoundedRectangle(radius: 4,
                                                           bgColor: .customPurple,
                                                           text: (vm.isRecentRideDone ? "다시 도전하기" : "이어하기"))
                                }
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 17.5, trailing: 12))
                }
                .frame(width: 155, height: 145)
            }
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 8).fill(.main))
        }
    }
}
