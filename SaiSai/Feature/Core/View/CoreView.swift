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
            if vm.isSplashRepresented {
                Image(.icSplashImg)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                if vm.isLoggedIn {
                    MainView()
                } else {
                    LoginView(vm: LoginViewModel(delegate: self.vm))
                }
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
