//
//  CourseDetailInstructionView.swift
//  SaiSai
//
//  Created by ch on 8/24/25.
//

import SwiftUI
import Combine

struct CourseRidingInstructionView: View {
    
    let startButtonOnInstructionPublisher: PassthroughSubject<Bool, Never>
    let instructions: [String] = [
        "일시정지 후 12시간이 지나면 주행 기록이 초기화돼요.",
        "일시정지 된 코스는 코스 기록에서 확인할 수 있어요."
    ]
    @State var isNeverAgainOn: Bool = false
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Spacer()
                
                Button {
                    isPresented.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 13.3, height: 13.3)
                        .foregroundColor(.white)
                }
            }
            
            Text("주행 안내사항")
                .font(.pretendard(.medium, size: 18))
                .foregroundStyle(.white)
                .padding(.bottom, 24)
            
            VStack(spacing: 12) {
                ForEach(instructions, id: \.self) { instruction in
                    HStack(spacing: 12) {
                        Image(.icInstructionBike)
                            .resizable()
                            .frame(width: 32, height: 32)
                        Text(instruction)
                            .font(.pretendard(size: 14))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                }
            }
            
            Button {
                isNeverAgainOn.toggle()
            } label: {
                HStack {
                    Image(systemName: isNeverAgainOn ? "checkmark.circle.fill" : "checkmark.circle")
                        .resizable()
                        .frame(width: 13, height: 13)
                        .foregroundStyle(isNeverAgainOn ? .white : .gray40)
                    
                    Text("다시 보지 않기")
                        .font(.pretendard(size: 12))
                        .foregroundStyle(.white)
                }
                .padding(.top, 38)
                .padding(.bottom, 20)
            }
            
            Button {
                startButtonOnInstructionPublisher.send(isNeverAgainOn)
            } label: {
                Text("코스 도전 시작")
                    .font(.pretendard(.semibold, size: 16))
                    .foregroundStyle(.black)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 8).fill(.customLime))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(RoundedRectangle(cornerRadius: 20).fill(.gray90))
    }
}
