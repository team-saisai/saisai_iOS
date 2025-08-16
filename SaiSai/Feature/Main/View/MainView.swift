//
//  MainView.swift
//  SaiSai
//
//  Created by 이창현 on 7/11/25.
//

import SwiftUI

class TabState: ObservableObject {
    @Published var selectedTab: Int = 0
}

struct MainView: View {
    
    @StateObject var tabState = TabState()
    
    var body: some View {
        NavigationStack {
            TabView(selection: $tabState.selectedTab) {
                HomeView()
                    .tabItem {
                        Image(.icHome)
                            .renderingMode(.template)
                        Text("홈")
                    }
                    .tag(0)
                CourseView()
                    .tabItem {
                        Image(.icCourse)
                            .renderingMode(.template)
                        Text("코스")
                    }
                    .tag(1)
                HistoryView()
                    .tabItem {
                        Image(.icHistory)
                            .renderingMode(.template)
                        Text("기록")
                    }
                    .tag(2)
                MypageView()
                    .tabItem {
                        Image(.icMypage)
                            .renderingMode(.template)
                        Text("마이")
                    }
                    .tag(3)
            }
            .tint(.white)
            .environmentObject(tabState)
        }
    }
    
    init() {
        UITabBar.appearance().barTintColor = UIColor.main
        UITabBar.appearance().backgroundColor = UIColor.main
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray50
    }
}

#Preview {
    MainView()
}
