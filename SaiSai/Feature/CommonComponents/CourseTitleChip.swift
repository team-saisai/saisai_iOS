//
//  CourseTitleChip.swift
//  SaiSai
//
//  Created by ch on 7/15/25.
//

import SwiftUI
import Combine

enum TitleChipType {
    case event
    case ended
    case ongoing(endedAt: String)
}

struct CourseTitleChip: View {
    
    @State var isEditing: Bool = false
    let titleChip: TitleChipType
    let isEditingPublisher: PassthroughSubject<Bool, Never>
    
    var body: some View {
        HStack(spacing: 3.5) {
            if case .ongoing = titleChip {
                Image(.icFireIcon)
                    .resizable()
                    .frame(width: 12.5, height: 14)
            }
            Text(text)
                .foregroundStyle(.white)
                .font(.pretendard(.medium, size: 12))
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 6)
        .background(RoundedRectangle(cornerRadius: 8).fill(bgColor))
        .onReceive(isEditingPublisher) {
            self.isEditing = $0
        }
    }
}

// MARK: - Init + Computed Property
extension CourseTitleChip {
    
    init(isEvent: Bool = false, challengeStatus: ChallengeStatus, endedAt: String?, isEditingPublisher: PassthroughSubject<Bool, Never> = .init()) {
        if isEvent {
            titleChip = .event
        } else {
            titleChip = (challengeStatus == .ended ? .ended : .ongoing(endedAt: endedAt ?? ""))
        }
        self.isEditingPublisher = isEditingPublisher
    }
    
    var text: String {
        switch titleChip {
        case .event: "이벤트"
        case .ended: "챌린지 종료"
        case .ongoing(let endedAt): endedAt.slashDateText
        }
    }
    var bgColor: Color {
        if isEditing { return .gray60 }
        
        switch titleChip {
        case .event:
            return .customLightPurple
        case .ended:
            return .chipBlack
        case .ongoing:
            return .titleChipRed
        }
    }
}
