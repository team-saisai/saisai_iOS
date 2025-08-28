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
                                lineWidth: vm.isCompleteButtonOn ? 1 : 0
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
                }
                .foregroundStyle(.white)
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 10)
            
            HStack(spacing: 4) {
                Image(
                    systemName: vm.isNicknameCharactersValid ?
                    "checkmark.circle" : "exclamationmark.circle"
                )
                .resizable()
                .frame(width: 14, height: 14)
                
                Text("영문/한글/숫자가능(공백불가)")
                    .font(.pretendard(size: 12))
                
                Spacer()
            }
            .padding(.vertical, 4)
            .foregroundStyle(vm.isNicknameCharactersValid ? .blue : .red)
            
            HStack(spacing: 4) {
                Image(
                    systemName: vm.isNicknameLengthValid ?
                    "checkmark.circle" : "exclamationmark.circle"
                )
                .resizable()
                .frame(width: 14, height: 14)
                
                Text("1자 이상 7자 이하 입력"
                )
                .font(.pretendard(size: 12))
                
                Spacer()
            }
            .padding(.vertical, 4)
            .foregroundStyle(vm.isNicknameLengthValid ? .blue : .red)
            
            Spacer()
            
            Button {
                vm.changeNickname()
            } label: {
                Text("완료")
                    .font(.pretendard(.semibold, size: 16))
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 8)
                        .fill(
                            vm.isCompleteButtonOn ?
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
        .padding(.horizontal, 24)
        .padding(.vertical, 25)
        .background(.gray90)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("닉네임 수정")
                    .font(.pretendard(.semibold, size: 16))
                    .foregroundColor(.white)
            }
            
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
        .onReceive(vm.nicknameChangeSuccessPublisher) { _ in
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}
