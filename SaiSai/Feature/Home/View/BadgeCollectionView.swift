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
        LazyVStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("뱃지 컬렉션")
                    .font(.pretendard(.semibold, size: 18))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.bottom, 16)
            
            BadgesContainerView(vm.badgeIds)
                .frame(maxWidth: .infinity, minHeight: 235)
        }
        .frame(maxHeight: .infinity)
    }
}

extension BadgeCollectionView {
    
    private func BadgesContainerView(_ badgeIds: [Int]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                ForEach(0...3, id: \.self) {
                    if $0 != 0 { Spacer() }
                    SingleBadgeContainerView(badgeIds[$0])
                }
            }
            
            HStack {
                ForEach(4...7, id: \.self) {
                    if $0 != 4 { Spacer() }
                    SingleBadgeContainerView(badgeIds[$0])
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.main)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func SingleBadgeContainerView(_ badgeIds: Int) -> some View {
        VStack(spacing: 8) {
            ZStack {
//                if badge.badgeImageUrl.isEmpty {
//                    Circle().fill(.gray30)
//                } else {
//                    KFImage(URL(string: badge.badgeImageUrl)).resizable()
//                }
                // TODO: - 뱃지 수정 예정
                Circle().fill(.gray30)
            }
            .frame(width: 54, height: 54)
            .clipShape(Circle())
            
            // TODO: - 뱃지 텍스트 수정 예정
//            Text(badge.badgeName)
//                .font(.pretendard(.regular, size: 12))
//                .foregroundStyle(.gray70)
//                .lineLimit(1)
        }
        .frame(width: 60)
    }
}
