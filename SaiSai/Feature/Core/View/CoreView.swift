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
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                if !vm.isLoggedIn {
                    Image(.icSplashImg)
                        .resizable()
                        .ignoresSafeArea()
                    
                    if !vm.isCheckingSavedTokens {
                        LoginView(vm: LoginViewModel(delegate: self.vm))
                            .position(x: proxy.size.width / 2, y: proxy.size.height / 3 * 2)
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    vm.setIsToastPresented(false)
                }
            }
        }
    }
}

#Preview {
    CoreView()
}
