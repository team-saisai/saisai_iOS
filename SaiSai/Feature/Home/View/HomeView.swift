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
        ZStack {
            VStack {
                HomeHeaderView()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 40) {
                        HStack(spacing: 0) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("안녕하세요 \(vm.name)님!")
                                Text("오늘도 함께 달려보아요:)")
                            }
                            .font(.pretendard(.medium, size: 26))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            
                            Spacer()
                        }
                        
                        if vm.isLoading {
                            ProgressView()
                        } else {
                            if vm.isRecentRideExists { RecentCourseView(vm: vm) }
                            
                            PopularChallengesView(vm: vm)
                            
                            BadgeCollectionView(vm: vm)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            if vm.isRequestingBookmarks {
                VStack {
                    ProgressView()
                        .opacity(0.7)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.gray5.opacity(0.05))
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
