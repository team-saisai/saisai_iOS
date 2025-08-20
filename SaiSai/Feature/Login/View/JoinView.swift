//
//  JoinView.swift
//  SaiSai
//
//  Created by ch on 8/20/25.
//

import SwiftUI
import Combine

struct JoinView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var vm: JoinViewModel
    let buttonTappedPublisher: PassthroughSubject<Bool, Never> = .init()
    @State var isWKPresented: Bool = false
    @Binding var needsJoin: Bool
    
    init(
        vm: JoinViewModel,
        needsJoin: Binding<Bool>
    ) {
        self._vm = StateObject(wrappedValue: vm)
        self._needsJoin = needsJoin
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 14) {
                Spacer()
                
                HStack {
                    Button {
                        vm.setToAllOrNone()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 18, height: 18)
                                .foregroundStyle(vm.isAllChecked ? .purple : .gray70)
                            
                        }
                        
                        Text("서비스 약관 전체 동의")
                            .font(.pretendard(size: 15))
                    }
                    
                    Spacer()
                }
                
                Divider()
                    .overlay { Color.gray80 }
                
                HStack {
                    Button {
                        vm.toggleIsUseAndPrivacyTerms()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark")
                                .resizable()
                                .frame(width: 12.4, height: 9.2)
                                .foregroundStyle(vm.isUseAndPrivacyTermsChecked ? .purple : .gray70)
                            
                        }
                        
                        Text("[필수] 이용약관 및 개인정보 처리방침")
                            .font(.pretendard(size: 14))
                    }
                    
                    Spacer()
                    
                    Button {
                        isWKPresented.toggle()
                    } label: {
                        Text("자세히")
                            .font(.pretendard(size: 11))
                            .foregroundStyle(.gray50)
                            .underline(true, color: .gray50)
                            .sheet(isPresented: $isWKPresented) {
                                TermsWebView()
                            }
                    }
                }
                
                HStack {
                    Button {
                        vm.toggleIsAgeTermsChecked()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark")
                                .resizable()
                                .frame(width: 12.4, height: 9.2)
                                .foregroundStyle(vm.isAgeTermsChecked ? .purple : .gray70)
                            
                            Text("[필수] 만 14세 이상입니다.")
                                .font(.pretendard(size: 14))
                        }
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 43)
                
                Button {
                    if vm.isAllChecked {
                        vm.setIsAlertPresented(true)
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("회원가입")
                        Spacer()
                    }
                }
                .font(.pretendard(.medium, size: 16))
                .foregroundStyle(.gray90)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(vm.isAllChecked ? .customLime : .gray70)
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 45)
            .foregroundStyle(.gray20)
            .background(.gray90)
            
            if vm.isAlertPresented{
                Color.gray30.opacity(0.1)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            vm.setIsAlertPresented(false)
                        }
                    }
                
                CustomTwoButtonAlert(
                    buttonTitleText: "회원가입 하시겠습니까?",
                    buttonText: "회원가입",
                    isAction: true,
                    buttonTappedPublisher: buttonTappedPublisher
                )
            }
        }
        .navigationTitle("회원 가입")
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
            if $0 {
                OAuthTokenStore.shared.completionHandler(vm.getToken())
                needsJoin = false
                self.presentationMode.wrappedValue.dismiss()
            }
            vm.setIsAlertPresented(false)
        }
    }
}
