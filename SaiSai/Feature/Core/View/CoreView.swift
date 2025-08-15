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
            if vm.isSplashRepresented || !vm.isLoggedIn {
                Image(.icSplashImg)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                if !vm.isLoggedIn {
                    LoginView(vm: LoginViewModel(delegate: self.vm))
                }
            } else {
                MainView()
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
