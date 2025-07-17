//
//  LoginView.swift
//  SaiSai
//
//  Created by ch on 7/9/25.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var vm: LoginViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            TextField("이메일", text: $vm.emailText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textContentType(.emailAddress)
            
            SecureField("패스워드", text: $vm.passwordText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textContentType(.password)
            
            Button {
                vm.requestLogin()
            } label: {
                Text("로그인")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(12)
            }
            
            Spacer()
        }
        .padding(.horizontal, 50)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
