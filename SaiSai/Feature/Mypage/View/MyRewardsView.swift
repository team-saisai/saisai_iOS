//
//  MyRewardsView.swift
//  SaiSai
//
//  Created by ch on 8/17/25.
//

import SwiftUI

struct MyRewardsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var vm: MyRewardsViewModel = .init()
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                VStack {
                    Image(.icRewardsIcon)
                        .resizable()
                        .frame(width: 90, height: 90)
                }
                
                Text("나의 리워드")
                    .font(.pretendard(.medium, size: 12))
                    .foregroundStyle(.gray60)
                    .padding(.top, 12)
                    .padding(.bottom, 2)
                
                Text("\(vm.totalReward)P")
                    .foregroundStyle(.customLime)
                    .font(.pretendard(size: 22))
                    .padding(.bottom, 20)
            }
            
            if !vm.rewardsList.isEmpty {
                ForEach(vm.rewardsList.indices, id: \.self) {
                    SingleRewardView(vm.rewardsList[$0])
                    
                    Divider()
                        .overlay {
                            Rectangle().fill(Color.gray70)
                        }
                }
            } else {
                VStack {
                    Spacer()
                    Text("리워드 내역이 없습니다.")
                        .font(.pretendard(.medium, size: 16))
                    Spacer()
                }
            }
        }
        .onAppear {
            vm.fetchData()
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 22)
        .background(.gray90)
        .navigationTitle("리워드 포인트")
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

extension MyRewardsView {
    @ViewBuilder
    private func SingleRewardView(_ rewardInfo: RewardInfo) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(String(rewardInfo.acquiredAt.prefix(10)).dottedDateText)")
                    .font(.pretendard(size: 12))
                    .foregroundStyle(.gray60)
                Spacer()
            }
            .padding(.bottom, 6)
            
            HStack {
                Text("\(rewardInfo.courseName)")
                Spacer()
                Text("+\(rewardInfo.reward)")
            }
            .font(.pretendard(size: 15))
            .foregroundStyle(.white)
            .padding(.horizontal, 2)
        }
        .padding(.vertical, 18)
    }
}
