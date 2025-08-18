//
//  EmptyCourseListView.swift
//  SaiSai
//
//  Created by ch on 8/17/25.
//

import SwiftUI
import Combine

struct EmptyCourseListView: View {
    
    let messageText: String
    let moveToCourseButtonTappedPublisher: PassthroughSubject<Void, Never>
    let buttonVisibility: Bool
    
    init(
        messageText: String,
        moveToCourseButtonTappedPublisher: PassthroughSubject<Void, Never> = .init(),
        buttonVisibility: Bool = true
    ) {
        self.messageText = messageText
        self.moveToCourseButtonTappedPublisher = moveToCourseButtonTappedPublisher
        self.buttonVisibility = buttonVisibility
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(.icBigBike)
                .resizable()
                .frame(width: 201, height: 132)
            
            VStack(spacing: 2) {
                Text(messageText)
            }
            .font(.pretendard(.medium, size: 16))
            .foregroundStyle(.white)
            .padding(.bottom, 16)
            
            if buttonVisibility {
                Button {
                    moveToCourseButtonTappedPublisher.send()
                } label: {
                    Text("코스 보러가기")
                        .font(.pretendard(.semibold, size: 15))
                        .foregroundStyle(.gray90)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 90)
                        .background(RoundedRectangle(cornerRadius: 6).fill(.customLime))
                }
                
                Spacer()
            }
        }
    }
}
