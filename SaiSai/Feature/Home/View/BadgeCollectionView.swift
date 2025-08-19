//
//  BadgeCollectionView.swift
//  SaiSai
//
//  Created by 이창현 on 7/17/25.
//

import SwiftUI
import Kingfisher

struct BadgeCollectionView: View {
    
    @ObservedObject var vm: HomeViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("나의 뱃지")
                    .font(.pretendard(.semibold, size: 18))
                    .foregroundStyle(.white)
                
                Spacer()
            }
            
            VStack(spacing: 24) {
                if !vm.badges.isEmpty {
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
                }
            }
            .padding(.all, 24)
            .background(RoundedRectangle(cornerRadius: 12).fill(.dropDownBg))
        }
    }
}

extension BadgeCollectionView {
    private func SingleBadgeView(_ badge: BadgeInfo) -> some View {
        VStack(spacing: 0) {
            if let image = badge.image {
                KFImage(URL(string: image))
                    .placeholder {
                        Image(.icLockedBadgeIcon)
                    }
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
            } else {
                Image(.icLockedBadgeIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
            }
            
            Text("\(badge.name)")
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .font(.pretendard(size: 12))
                .foregroundStyle(.white)
                .padding(.top, 8)
            
            Spacer()
        }
        .frame(width: 85, height: 130)
    }
}
