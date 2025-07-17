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
            LazyVStack(spacing: 40) {
                HomeHeaderView(vm: vm)

                if vm.isRecentRideExists { RecentCourseView(vm: vm) }

                PopularChallengesView(vm: vm)
                
                BadgeCollectionView(vm: vm)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 20)
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
