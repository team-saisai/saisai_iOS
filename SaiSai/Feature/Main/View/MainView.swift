//
//  MainView.swift
//  SaiSai
//
//  Created by 이창현 on 7/11/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            TabView {
                HomeView()
                    .tabItem {
                        Image(.icHome)
                            .renderingMode(.template)
                        Text("홈")
                    }
                CourseView()
                    .tabItem {
                        Image(.icCourse)
                            .renderingMode(.template)
                        Text("코스")
                    }
                HistoryView()
                    .tabItem {
                        Image(.icHistory)
                            .renderingMode(.template)
                        Text("기록")
                    }
                MypageView()
                    .tabItem {
                        Image(.icMypage)
                            .renderingMode(.template)
                        Text("마이")
                    }
            }
            .tint(.white)
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
