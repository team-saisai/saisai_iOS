//
//  CourseCompleteView.swift
//  SaiSai
//
//  Created by ch on 8/24/25.
//

import SwiftUI
import Kingfisher
import Combine

struct CourseCompleteView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var tabState: TabState
    @ObservedObject var vm: CourseDetailViewModel
    
    var body: some View {
        VStack {
            Text("수고하셨습니다!")
                .font(.pretendard(.medium, size: 18))
                .foregroundStyle(.white)
                .padding(.bottom, 30)
            
            CompletedCourseImageView()
            
            Button {
                UIApplication.popToRoot()
                tabState.selectedTab = 0
            } label: {
                HStack {
                    Text("홈으로 돌아가기")
                        .font(.pretendard(size: 16))
                        .foregroundStyle(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 22)
                        .background(RoundedRectangle(cornerRadius: 30).fill(.courseDetailBg))
                }
                .padding(.top, 50)
            }
        }
        .padding(.vertical, 42)
        .padding(.horizontal, 35)
        .background(.menuItemDefaultBg.opacity(0.86))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    UIApplication.popBack(2)
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 9, height: 18)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                }
            }
        }
    }
}

extension CourseCompleteView {
    @ViewBuilder
    private func CompletedCourseImageView() -> some View {
        VStack(spacing: 0) {
            KFImage(URL(string: (vm.courseDetail?.imageUrl ?? "")))
                .resizable()
                .placeholder({
                    Image(systemName: "photo")
                        .foregroundStyle(.gray50)
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack(spacing: 0) {
                HStack {
                    Text(vm.courseDetail?.courseName ?? "")
                        .font(.pretendard(.medium, size: 20))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                    
                    Spacer()
                }
                .padding(.bottom, 11)
                
                HStack(spacing: 7) {
                    Text("총 \(String(format: "%.1f", vm.courseDetail?.distance ?? 0.0))km")
                        .foregroundStyle(.gray40)
                    Text(vm.spentSeconds.formattedTime)
                        .foregroundStyle(.customLightPurple)
                    Spacer()
                }
                .font(.pretendard(size: 14))
            }
            .padding(.top, 19)
            .padding(.bottom, 28)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .background(.black)
        }
        .background(RoundedRectangle(cornerRadius: 16))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
