//
//  CourseDetailBottomItem.swift
//  SaiSai
//
//  Created by 이창현 on 7/20/25.
//

import SwiftUI

struct CourseDetailBottomItem: View {
    
    @ObservedObject var vm: CourseDetailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            LazyVStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    CourseDetailSummaryView()
                    
                    Spacer()
                    
                    ChallengeButton()
                }
                
                HStack(spacing: 11) {
                    HStack(spacing: 5) {
                        Image(.icThunderIcon)
                            .resizable()
                            .frame(width: 11.7, height: 16.6)
                        Text("\(vm.courseDetail?.challengerCount.commaDecimal ?? "")명 도전중")
                    }
                    HStack(spacing: 3.5) {
                        Image(.icStarInCircle)
                            .frame(width: 15, height: 15)
                        Text("\(vm.courseDetail?.finisherCount.commaDecimal ?? "")명 완주")
                    }
                    Spacer()
                }
                .font(.pretendard(.regular, size: 12))
                .foregroundStyle(.iconPurple)
                
                if !vm.isSummaryViewFolded {
                    SummaryView()
                        .padding(.top, 24)
                }
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 22)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.courseDetailBg))
            
            FoldButton()
        }
    }
}

extension CourseDetailBottomItem {
    private func ChallengeButton() -> some View {
        VStack(spacing: 6) {
            Button {
                // TODO: - 도전하기 API 추가
            } label: {
                VStack(spacing: 6.5) {
                    Image(.icBicycle)
                        .resizable()
                        .frame(width: 26.4, height: 15.2)
                    
                    Text("도전하기")
                        .font(.pretendard(.semibold, size: 12))
                        .foregroundStyle(.gray90)
                }
                .padding(EdgeInsets(top: 16.5, leading: 6, bottom: 12, trailing: 6))
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.customLime))
            }
            
            Text("\(vm.courseDetail?.estimatedHour ?? 0)h \(vm.courseDetail?.estimatedMinute ?? 0)m")
                .font(.pretendard(size: 12))
                .foregroundStyle(.customLime)
        }
    }
    
    private func CourseDetailSummaryView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(vm.courseDetail?.courseName ?? "")
                .font(.pretendard(size: 20))
                .foregroundStyle(.white)
                .padding(.bottom, 6)
            
            HStack(spacing: 5) {
                Text("\(String(format: "%.1f", vm.courseDetail?.distance ?? 0.0))km")
                Text("·")
                LevelView(level: vm.courseDetail?.level ?? 0)
            }
            .padding(.bottom, 8)
            .font(.pretendard(size: 12))
            .foregroundStyle(.gray40)
        }
    }

    private func SummaryView() -> some View {
        Text(vm.courseDetail?.summary ?? "")
            .foregroundStyle(.white)
            .font(.pretendard(.regular, size: 14))
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
    }
    
    private func FoldButton() -> some View {
        Button {
            vm.toggleSummaryFoldState()
        } label: {
            VStack {
                Image(systemName: vm.isSummaryViewFolded ? "chevron.down" : "chevron.up")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 40, height: 4)
                    .foregroundStyle(.gray20)
            }
            .frame(width: 200, height: 10)
            .background(.courseDetailBg)
            .clipShape(RoundedRectangle(cornerRadius: 16).trim(from: 0, to: 0.5))
        }
    }
}
