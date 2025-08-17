//
//  CoreView.swift
//  SaiSai
//
//  Created by ch on 7/9/25.
//

import SwiftUI

struct CoreView: View {
    
    @StateObject var vm: CoreViewModel = .init()
    
    var body: some View {
        ZStack {
            if !vm.isLoggedIn {
                Image(.icSplashImg)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                if !vm.isCheckingSavedTokens {
                    LoginView(vm: LoginViewModel(delegate: self.vm))
                }
            } else {
                MainView(vm: MainViewModel(delegate: self.vm))
            }
        }
        .onAppear {
            vm.validateToken()
        }
    }
}

#Preview {
    CoreView()
}
