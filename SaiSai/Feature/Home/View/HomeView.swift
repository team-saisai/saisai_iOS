//
//  ContentView.swift
//  SaiSai
//
//  Created by yeosong on 7/5/25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var vm: HomeViewModel = .init()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HomeHeaderView(vm: vm)
                
                // MARK: - 최근 코스(API 연동?)
                if vm.isRecentRideExists {
                    RecentCourseView(vm: vm)
                        .padding(.bottom, 40)
                }
                // MARK: - 인기 챌린지(API 연동)
                PopularCoursesView(vm: vm)
                
                // BadgeCollectionView()
            }
            .padding(.top, 20)
            .padding(.horizontal, 24)
        }
        .padding(.top, 1)
        .background(.gray90)
        .onAppear {
            vm.fetchData()
        }
    }
}

#Preview {
    HomeView()
}
