//
//  CustomDropDown.swift
//  SaiSai
//
//  Created by 이창현 on 8/5/25.
//

import SwiftUI
import Combine

struct CustomDropDown: View {

    @State var isFolded: Bool = true
    @State var selectedOption: CourseSortOption = .levelAsc
    
    let optionPublisher: PassthroughSubject<CourseSortOption, Never>
    
    var body: some View {
        VStack(spacing: 4) {
            Button {
                isFolded.toggle()
            } label: {
                HStack {
                    Text("\(selectedOption.dropDownText)")
                    
                    Image(systemName: isFolded ? "arrowtriangle.down.fill" : "arrowtriangle.up.fill")
                        .resizable()
                        .frame(width: 7, height: 3.5)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(RoundedRectangle(cornerRadius: 8).fill(.dropDownBg))
            }
            
            if !isFolded {
                VStack(spacing: 0) {
                    ForEach(CourseSortOption.allCases, id: \.self) { option in
                        Button {
                            optionPublisher.send(option)
                            isFolded = true
                            selectedOption = option
                        } label: {
                            Text("\(option.dropDownText)")
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(selectedOption == option ? .iconPurple : .white)
                                .background(RoundedRectangle(cornerRadius: 4).fill(Color.menuItemHighlightedBg.opacity(
                                    selectedOption == option ? 1 : 0
                                )))
                        }
                    }
                }
                .padding(.all, 4)
                .frame(width: 107)
                .overlay {
                    RoundedRectangle(cornerRadius: 8).stroke(Color.gray40, lineWidth: 1)
                }
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.menuItemDefaultBg))
            }
        }
        .font(.pretendard(.regular, size: 13))
    }
}
