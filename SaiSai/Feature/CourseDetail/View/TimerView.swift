//
//  TimerView.swift
//  SaiSai
//
//  Created by 이창현 on 7/24/25.
//

import SwiftUI

struct TimerView: View {
    
    @ObservedObject var vm: CourseDetailViewModel
    
    var body: some View {
        Text("\(vm.spentSeconds.formattedTime)")
            .font(.pretendard(.regular, size: 18))
            .foregroundStyle(.customLightPurple)
            .padding(.vertical, 8)
            .padding(.horizontal, 17)
            .background(RoundedRectangle(cornerRadius: 40).fill(.timerBgPurple))
    }
}
