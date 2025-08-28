//
//  CoreView.swift
//  SaiSai
//
//  Created by ch on 7/9/25.
//

import SwiftUI

struct CoreView: View {
    
    @StateObject var vm: CoreViewModel = .init()
    @State var toastType: ToastType = .requestFailure
    @State var needsJoin: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { proxy in
                    if !vm.isLoggedIn {
                        Image(.icSplashImg)
                            .resizable()
                            .ignoresSafeArea()
                        
                        if !vm.isCheckingSavedTokens {
                            LoginView(vm: LoginViewModel(delegate: self.vm))
                                .position(x: proxy.size.width / 2, y: proxy.size.height / 3 * 2)
                                .navigationDestination(isPresented: $needsJoin) {
                                    JoinView(
                                        vm: JoinViewModel(),
                                        needsJoin: $needsJoin
                                    )
                                }
                        }
                    } else {
                        MainView(vm: MainViewModel(delegate: self.vm))
                    }
                    
                    if vm.isToastPresented {
                        VStack {
                            Color.clear
                        }
                        .overlay {
                            VStack {
                                CustomToastView(
                                    toastType: $toastType,
                                    vm: vm
                                )
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                }
            }
        }
        .onAppear {
            vm.validateToken()
        }
        .onReceive(ToastManager.shared.toastPublisher) { toast in
            DispatchQueue.main.async {
                self.toastType = toast
            }
            vm.setIsToastPresented(true)
            withAnimation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    vm.setIsToastPresented(false)
                }
            }
        }
        .onReceive(OAuthTokenStore.shared.isJoinPublisher) {
            needsJoin = true
        }
    }
}

#Preview {
    CoreView()
}
