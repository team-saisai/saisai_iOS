//
//  NicknameChangeView.swift
//  SaiSai
//
//  Created by ch on 8/12/25.
//

import SwiftUI

struct NicknameChangeView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var vm: NicknameChangeViewModel
    
    var isCompleteButtonOn: Bool {
        if let isInputNicknameValid = vm.isInputNicknameValid {
            return (isInputNicknameValid ? true : false)
        }
        return false
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 6).fill(.dropDownBg)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .overlay {
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(
                                Color.gray60,
                                lineWidth: vm.shouldHigihlight ? 1 : 0
                            )
                    }
                
                HStack(spacing: 0) {
                    TextField(text: $vm.nickname) {
                        Text("\(vm.nickname)")
                            .font(.pretendard(.medium, size: 14))
                    }
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    
                    Spacer()
                    
                    Text("\(vm.nickname.count)/10")
                        .font(.pretendard(size: 13))
                        .monospaced()
                        .padding(.horizontal, 12)
                    
                    Button {
                        if vm.shouldHigihlight {
                            vm.checkIfNicknameExists()
                        }
                    } label: {
                        Text("중복확인")
                            .font(.pretendard(.medium, size: 12))
                            .foregroundStyle(vm.shouldHigihlight ? .customLime : .gray70)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .overlay {
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(
                                        vm.shouldHigihlight ? Color.customLime : Color.gray70,
                                        lineWidth: 1
                                    )
                            }
                    }
                }
                .foregroundStyle(.white)
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
            }
            
            if vm.isSubtextVisible {
                if let isValid = vm.isInputNicknameValid {
                    HStack(spacing: 4) {
                        Image(
                            systemName: isValid ?
                              "checkmark.circle" : "exclamationmark.circle"
                        )
                        .resizable()
                        .frame(width: 14, height: 14)
                        
                        Text(isValid ?
                             "사용 가능한 닉네임입니다." : "사용 중인 닉네임입니다."
                        )
                        .font(.pretendard(size: 12))
                        .padding(.vertical, 8)
                        
                        Spacer()
                    }
                    .foregroundStyle(isValid ? .blue : .red)
                }
            }
            
            Spacer()
            
            Button {
                if let isValid = vm.isInputNicknameValid, isValid {
                    vm.changeNickname()
                }
            } label: {
                Text("완료")
                    .font(.pretendard(.semibold, size: 16))
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 8)
                        .fill(
                            isCompleteButtonOn ?
                                .customLime : .gray80))
                    .foregroundStyle(.gray90)
            }
        }
        .onChange(of: vm.nickname, { oldValue, newValue in
            vm.nicknameChangeHandler(
                oldValue: oldValue,
                newValue: newValue
            )
        })
        .ignoresSafeArea(.all)
        .padding(.horizontal, 24)
        .padding(.vertical, 25)
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
                            .frame(width: 6, height: 12)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                }
            }
        }
        .onReceive(vm.NicknameChangeSuccessPublisher) { _ in
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}
