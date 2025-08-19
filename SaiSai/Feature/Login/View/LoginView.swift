//
//  LoginView.swift
//  SaiSai
//
//  Created by ch on 7/9/25.
//

import SwiftUI
import KakaoSDKUser
import KakaoSDKCommon

struct LoginView: View {
    
    @StateObject var vm: LoginViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
//            TextField("이메일",
//                      text: $vm.emailText,
//                      prompt: Text("\(vm.emailText)").foregroundStyle(.white)
//            )
//                .textInputAutocapitalization(.never)
//                .autocorrectionDisabled()
//                .textContentType(.emailAddress)
//                .padding(.all, 8)
//                .background(RoundedRectangle(cornerRadius: 6).fill(.gray60))
//            
//            SecureField("패스워드",
//                        text: $vm.passwordText,
//                        prompt: Text("\(vm.passwordText)").foregroundStyle(.white)
//            )
//                .textInputAutocapitalization(.never)
//                .autocorrectionDisabled()
//                .textContentType(.password)
//                .padding(.all, 8)
//                .background(RoundedRectangle(cornerRadius: 6).fill(.gray60))
//            
//            Button {
//                vm.requestLogin()
//            } label: {
//                Text("로그인")
//                    .font(.system(size: 18, weight: .medium))
//                    .foregroundStyle(.white)
//                    .padding(.vertical, 12)
//                    .frame(maxWidth: .infinity)
//                    .background(.blue)
//                    .cornerRadius(12)
//            }
            
            HStack(spacing: 20) {
                Button {
                    vm.requestAppleLogin()
                } label: {
                    Image(.icAppleLogo)
                        .resizable()
                        .frame(width: 48, height: 48)
                }
                
                Button {
                    vm.requestGoogleLogin()
                } label: {
                    Image(.icGoogleLogo)
                        .resizable()
                        .frame(width: 48, height: 48)
                }
                
                Button {
                    vm.requestKakaoLogin()
                } label: {
                    Image(.icKakaoLogo)
                        .resizable()
                        .frame(width: 48, height: 48)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 50)
        .background(.clear)
    }
}
