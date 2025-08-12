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
        VStack {
            TextField(text: $vm.nickname) {
                HStack {
                    Text("\(vm.nickname)")
                        .font(.pretendard(.medium, size: 14))
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("중복확인")
                            .overlay {
                                RoundedRectangle(cornerRadius: 4).stroke(Color.customLime, lineWidth: 1)
                            }
                    }
                }
                .foregroundStyle(.white)
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .background(RoundedRectangle(cornerRadius: 6).fill(.dropDownBg))
            }
            
            Spacer()
            
            Button {
                
            } label: {
                
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 25)
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
    }
}
