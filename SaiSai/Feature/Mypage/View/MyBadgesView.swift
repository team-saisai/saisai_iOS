//
//  MyBadgesView.swift
//  SaiSai
//
//  Created by ch on 8/17/25.
//

import SwiftUI
import Kingfisher

struct MyBadgesView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var vm: MyBadgesViewModel = .init()
    
    var body: some View {
        ZStack {
            if !vm.badges.isEmpty {
                VStack(spacing: 32) {
                    ForEach(0...(vm.badges.count - 1) / 3, id: \.self) { row in
                        HStack {
                            ForEach(0...2, id: \.self) { col in
                                SingleBadgeView(vm.badges[row * 3 + col])
                                if col != 2 {
                                    Spacer()
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.all, 30)
            }
            
            if vm.isModalPresented {
                Color.gray30.opacity(0.1)
                    .ignoresSafeArea()
                    .onTapGesture {
                        vm.setIsModalPresented(false)
                    }
                
                BadgeDetailModalView()
            }
        }
        .onAppear {
            vm.fetchData()
        }
        .background(.gray90)
        .navigationTitle("나의 뱃지")
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
    }
}

extension MyBadgesView {
    @ViewBuilder
    private func BadgeDetailModalView() -> some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button {
                    vm.setIsModalPresented(false)
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 13.3, height: 13.3)
                        .foregroundStyle(.white)
                }
            }
            
            HStack {
                if let image = vm.modalBadge?.image {
                    KFImage(URL(string: image))
                        .placeholder {
                            Image(.icLockedBadgeIcon)
                        }
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                } else {
                    Image(.icLockedBadgeIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                }
            }
            .padding(.top, 6)
            .padding(.bottom, 12)
            
            
            VStack(spacing: 0) {
                Text("\(vm.modalBadge?.name ?? "")")
                    .font(.pretendard(.medium, size: 22))
                    .foregroundStyle(.white)
                
                Text("\(vm.modalBadge?.condition ?? "")")
                    .font(.pretendard(size: 14))
                    .foregroundStyle(.customLime)
                    .padding(.top, 7)
                
                Text("\(vm.modalBadge?.description ?? "")")
                    .multilineTextAlignment(.center)
                    .font(.pretendard(size: 15))
                    .foregroundStyle(.gray10)
                    .padding(.top, 16)
            }
            .padding(.vertical, 28.5)
            .padding(.horizontal, 24)
        }
        .padding(.top, 28.5)
        .padding(.bottom, 32)
        .padding(.horizontal, 20)
        .background(RoundedRectangle(cornerRadius: 24).fill(.gray90))
        .frame(width: 320)
    }
    
    @ViewBuilder
    private func SingleBadgeView(_ badge: BadgeInfo) -> some View {
        Button {
            vm.setModalBadge(badge)
            vm.setIsModalPresented(true)
        } label: {
            VStack(spacing: 0) {
                if let image = badge.image {
                    KFImage(URL(string: image))
                        .placeholder {
                            Image(.icLockedBadgeIcon)
                        }
                        .resizable()
                        .scaledToFit()
                        .frame(height: 94)
                } else {
                    Image(.icLockedBadgeIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 94)
                }
                
                Text("\(badge.name)")
                    .lineLimit(nil)
                    .font(.pretendard(size: 13))
                    .foregroundStyle(.white)
                    .padding(.top, 12)
                
                Spacer()
            }
            .frame(width: 94, height: 150)
        }
    }
}
