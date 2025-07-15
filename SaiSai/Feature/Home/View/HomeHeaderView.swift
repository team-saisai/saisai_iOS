//
//  HomeHeaderView.swift
//  SaiSai
//
//  Created by 이창현 on 7/13/25.
//

import SwiftUI

struct HomeHeaderView: View {
    
    @ObservedObject var vm: HomeViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("사이사이")
                    .font(.hakgoyansimSamulham)
                    .foregroundStyle(.white)
                Spacer()
                Button(action: {
                    // TODO: - 알림 버튼 기능 구현
                    print("알림 버튼 클릭")
                }, label: {
                    Image("icBell")
                })
            }
            .padding(.bottom, 24)
            
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("안녕하세요 \(vm.name)님!")
                    Text("오늘도 함께 달려보아요:)")
                }
                .font(.pretendard(.medium, size: 26))
                .foregroundStyle(.white)
                
                Spacer()
            }
        }
    }
}
