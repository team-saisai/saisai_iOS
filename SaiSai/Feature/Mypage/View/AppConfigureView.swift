//
//  AppConfigureView.swift
//  SaiSai
//
//  Created by ch on 8/16/25.
//

import SwiftUI
import Combine

struct AppConfigureView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var vm: AppConfigureViewModel
    let buttonTappedPublisher: PassthroughSubject<Bool, Never> = .init()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Text("계정 설정")
                        .font(.pretendard(.medium, size: 15))
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.top, 40)
                .padding(.bottom, 12)
                .padding(.leading, 7)
                
                Button {
                    vm.setIsLogoutAlertPresented(true)
                } label: {
                    HStack {
                        AppConfigureTextView("로그아웃")
                        Spacer()
                    }
                }
                
                Divider()
                
                Button {
                    vm.setIsRemoveAccountAlertPresented(true)
                } label: {
                    HStack {
                        AppConfigureTextView("회원탈퇴")
                        Spacer()
                    }
                }
                
                Divider()
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            /// Alert Background View
            if vm.isLogoutAlertPresented || vm.isRemoveAccountAlertPresented {
                Color.gray30.opacity(0.1)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            vm.removeAlert()
                        }
                    }
            }
            
            if vm.isLogoutAlertPresented {
                CustomTwoButtonAlert(
                    buttonTitleText: "로그아웃 하시겠습니까?",
                    buttonText: "로그아웃",
                    isAction: true,
                    buttonTappedPublisher: buttonTappedPublisher
                )
            }
            
            if vm.isRemoveAccountAlertPresented {
                CustomTwoButtonAlert(
                    buttonTitleText: "회원탈퇴 하시겠습니까?",
                    buttonMessageText: "탈퇴 후에는 복구할 수 없습니다.",
                    buttonText: "회원탈퇴",
                    isDestructive: true,
                    buttonTappedPublisher: buttonTappedPublisher
                )
            }
        }
        .background(.gray90)
        .navigationTitle("닉네임 수정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 9, height: 18)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                }
            }
        }
        .onReceive(buttonTappedPublisher) {
            if vm.isLogoutAlertPresented {
                withAnimation {
                    vm.removeAlert()
                }
                if $0 { vm.requestLogout() }
            } else {
                withAnimation {
                    vm.removeAlert()
                }
                if $0 { vm.requestRemoveAccount() }
            }
        }
    }
}

extension AppConfigureView {
    @ViewBuilder
    private func AppConfigureTextView(_ text: String) -> some View {
        Text(text)
            .font(.pretendard(size: 15))
            .foregroundStyle(.gray20)
            .padding(.vertical, 21)
            .padding(.leading, 8)
    }
}
