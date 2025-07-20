//
//  MainView.swift
//  SaiSai
//
//  Created by 이창현 on 7/11/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(.home)
                        .renderingMode(.template)
                    Text("홈")
                }
            CourseView()
                .tabItem {
                    Image(.course)
                        .renderingMode(.template)
                    Text("코스")
                }
            HistoryView()
                .tabItem {
                    Image(.history)
                        .renderingMode(.template)
                    Text("기록")
                }
            MypageView()
                .tabItem {
                    Image(.mypage)
                        .renderingMode(.template)
                    Text("마이")
                }
        }
        .tint(.white)
        
    }
    init() {
        UITabBar.appearance().barTintColor = UIColor.main
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray50
    }
}

#Preview {
    MainView()
}
