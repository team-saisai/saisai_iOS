//
//  CustomTwoButtonAlert.swift
//  SaiSai
//
//  Created by ch on 8/16/25.
//

import SwiftUI
import Combine

struct CustomTwoButtonAlert: View {
    
    private let buttonTitleText: String
    private let buttonMessageText: String?
    private let buttonType: ButtonType
    private let buttonText: String
    
    let buttonTappedPublisher: PassthroughSubject<Bool, Never>
    
    init(
        buttonTitleText: String,
        buttonMessageText: String? = nil,
        buttonText: String,
        isAction: Bool = false,
        isDestructive: Bool = false,
        buttonTappedPublisher: PassthroughSubject<Bool, Never>
    ) {
        self.buttonTitleText = buttonTitleText
        self.buttonMessageText = buttonMessageText
        self.buttonText = buttonText
        self.buttonTappedPublisher = buttonTappedPublisher
        
        var button: ButtonType = .normal
        if isAction { button = .action }
        if isDestructive { button = .destructive }
        
        self.buttonType = button
    }
    
    var body: some View {
        VStack {
            Text(buttonTitleText)
                .font(.pretendard(.medium, size: 18))
                .foregroundStyle(.white)
            
            if let messageText = buttonMessageText {
                Text(messageText)
                    .font(.pretendard(size: 14))
                    .foregroundStyle(.gray40)
                    .padding(.top, 7)
            }
            
            HStack(spacing: 10) {
                AlertButton(false, "취소", .normal)
                AlertButton(true, buttonText, buttonType)
            }
            .padding(.top, 32)
        }
        .padding(.top, 30)
        .padding(.bottom, 20)
        .padding(.horizontal, 20)
        .background {
            RoundedRectangle(cornerRadius: 20).fill(.gray90)
        }
    }
}

extension CustomTwoButtonAlert {
    private enum ButtonType {
        case normal
        case action
        case destructive
        
        /// (배경색상, 글씨색상)
        var buttonColor: (Color, Color) {
            switch self {
            case .normal: return (.gray80, .white)
            case .action: return (.customLime, .black)
            case .destructive: return (.destructiveRed, .black)
            }
        }
    }
    
    @ViewBuilder
    private func AlertButton(_ isSecondButton: Bool, _ buttonText: String, _ buttonType: ButtonType) -> some View {
        Button {
            buttonTappedPublisher.send(isSecondButton)
        } label: {
            Text(buttonText)
                .frame(width: 135, height: 44)
                .background {
                    RoundedRectangle(cornerRadius: 8).fill(buttonType.buttonColor.0)
                }
                .foregroundStyle(buttonType.buttonColor.1)
        }
    }
}
