//
//  MypageView.swift
//  SaiSai
//
//  Created by 이창현 on 7/11/25.
//

import SwiftUI
import Kingfisher

struct MypageView: View {
    
    @EnvironmentObject var tabState: TabState
    @StateObject var vm: MypageViewModel
    @State var isWKRepresented: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Mypage")
                    .font(.hakgoyansimSamulham)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            .padding(.top, 20)
            
            ScrollView {
                VStack(spacing: 0) {
                    ProfileView()
                    
                    MypageDetailListView()
                    
                    MypageMenuView()
                    
                    Spacer()
                }
            }
        }
        .background(.gray90)
        .onAppear {
            vm.fetchData()
        }
    }
}

extension MypageView {
    @ViewBuilder
    private func ProfileView() -> some View {
        VStack(spacing: 0) {
            HStack {
                KFImage(URL(string:vm.profile.imageUrl ?? ""))
                    .placeholder {
                        Image(systemName: "person.fill")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 44, height: 44)
                            .foregroundStyle(.gray70)
                    }
                    .resizable()
                    .clipShape(Circle())
                    .scaledToFit()
                    .frame(width: 106, height: 106)
                    .overlay {
                        Circle()
                            .stroke(Color.gray70, lineWidth: 1)
                    }
            }
        }
        .padding(.bottom, 22)
        
        NavigationLink {
            NicknameChangeView(vm: NicknameChangeViewModel(nickname: vm.profile.nickname))
        } label: {
            HStack(spacing: 7) {
                Text("\(vm.profile.nickname)")
                Image(.icPencilIcon)
                    .resizable()
                    .frame(width: 14, height: 14)
            }
            .foregroundStyle(.white)
            .font(.pretendard(.medium, size: 24))
            .padding(.bottom, 8)
        }
        
        Text("\(vm.profile.email ?? "")")
            .foregroundStyle(.gray40)
            .font(.pretendard(.light, size: 14))
            .padding(.bottom, 28)
    }
}


extension MypageView {
    
    @ViewBuilder func SingleMypageVerticalItem(
        image: Image = Image(systemName: ""),
        highlightedText: String,
        defaultText: String
    ) -> some View {
        VStack {
            image
                .resizable()
                .frame(width: 44, height: 47)
            HStack(spacing: 1) {
                Text("\(highlightedText)")
                    .foregroundStyle(.customLime)
                Text("\(defaultText)")
                    .foregroundStyle(.white)
            }
            .font(.pretendard(.medium, size: 14))
            .padding(.vertical, 8)
            .padding(.horizontal, 12.8)
        }
    }
    
    @ViewBuilder
    private func MypageDetailListView() -> some View {
        
        let defaultTexts: [String] = [
            "코스", "코스", "P", "/9 뱃지"
        ]
        let highlightedTexts: [String] = [
            "\(vm.profile.rideCount)",
            "\(vm.profile.bookmarkCount)",
            "\(vm.profile.reward)",
            "\(vm.profile.badgeCount)"
        ]
        let images: [Image] = [
            Image(.icMypageHistoryIcon),
            Image(.icMypageSavedIcon),
            Image(.icMypageRewardsIcon),
            Image(.icMypageBadgeIcon)
        ]
        
        HStack {
            ForEach(0..<4) { idx in
                NavigationLink {
                    switch idx {
                    case 0:
                        CourseHistoryView()
                            .environmentObject(tabState)
                    case 1:
                        SavedCoursesView()
                            .environmentObject(tabState)
                    case 2:
                        MyRewardsView()
                            .environmentObject(tabState)
                    case 3:
                        MyBadgesView()
                    default:
                        let _ = 1
                    }
                } label: {
                    SingleMypageVerticalItem(
                        image: images[idx],
                        highlightedText: highlightedTexts[idx],
                        defaultText: defaultTexts[idx]
                    )
                }
                if idx != 3 {
                    Spacer()
                }
            }
        }
        .padding(.bottom, 24)
        .padding(.horizontal, 36)
    }
}

extension MypageView {
    @ViewBuilder
    private func MypageMenuView() -> some View {
        VStack(spacing: 0) {
            Divider()
            NavigationLink {
                AppConfigureView(vm: AppConfigureViewModel(
                    delegate: vm.delegate,
                    authProvider: vm.authProvider
                ))
            } label: {
                HStack {
                    Text("APP 설정")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 6, height: 12)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 23)
            }
            Divider()
            Button {
                self.isWKRepresented.toggle()
            } label: {
                HStack {
                    Text("서비스 이용 약관")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 6, height: 12)
                        .sheet(isPresented: $isWKRepresented) {
                            TermsWebView()
                        }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 23)
            }
            Divider()
            HStack {
                Text("버전 정보")
                Spacer()
                Text("ver \(vm.version)")
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 23)
        }
        .font(.pretendard(.regular, size: 15))
        .foregroundStyle(.white)
        .padding(.horizontal, 20)
    }
}
