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
        if vm.isLoggedIn {
            HomeView()
        } else {
            LoginView(vm: LoginViewModel(delegate: self.vm))
        }
    }
}

#Preview {
    CoreView()
}
