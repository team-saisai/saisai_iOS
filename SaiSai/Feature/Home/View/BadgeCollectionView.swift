//
//  BadgeCollectionView.swift
//  SaiSai
//
//  Created by ch on 7/15/25.
//

import SwiftUI

struct BadgeCollectionView: View {
    var body: some View {
        LazyVStack(alignment: .leading) {
            Text("뱃지 컬렉션")
                .font(.pretendard(.semibold, size: 18))
                .foregroundStyle(.white)
            
        }
    }
}

#Preview {
    BadgeCollectionView()
}
