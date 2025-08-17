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
        ScrollView(showsIndicators: false) {
            ZStack {
                LazyVStack(spacing: 40) {
                    HomeHeaderView(vm: vm)
                    
                    if vm.isLoading {
                        ProgressView()
                    } else {
                        if vm.isRecentRideExists { RecentCourseView(vm: vm) }
                        
                        PopularChallengesView(vm: vm)
                        
                        BadgeCollectionView(vm: vm)
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 20)
                
                if vm.isRequestingBookmarks {
                    VStack {
                        ProgressView()
                            .opacity(0.7)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.gray5.opacity(0.05))
                }
            }
        }
        .background(.gray90)
        .onAppear {
            vm.fetchData()
            vm.requestLocationPermission()
        }
    }
}

#Preview {
    HomeView()
}
