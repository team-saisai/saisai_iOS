//
//  CourseDetailView.swift
//  SaiSai
//
//  Created by 이창현 on 7/20/25.
//

import SwiftUI

struct CourseDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var vm: CourseDetailViewModel
    
    var body: some View {
        ZStack {
            VStack {
                CourseRidingView(vm: vm)
            }
            
            VStack(spacing: 8) {
                if vm.hasUncompletedRide {
                    VStack {
                        TimerView(vm: vm)
                    }
                    .padding(.top, 14)
                }
                
                Spacer()
                
                if vm.hasUncompletedRide {
                    RidingStatusBottomItem(vm: vm)
                } else {
                    CourseTitleChipsView()
                    CourseDetailBottomItem(vm: vm)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 18)
            .padding(.bottom, 42)
        }
        .onAppear {
            vm.fetchData()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray20)
        .navigationTitle(vm.courseDetail?.courseName ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                }
            }
        }
    }
}

extension CourseDetailView {
    @ViewBuilder
    private func CourseTitleChipsView() -> some View {
        HStack(spacing: 4) {
            CourseTitleChip(challengeStatus: vm.courseDetail?.challengeStatusCase ?? .ended,
                            endedAt: vm.courseDetail?.challengeEndedAt ?? "")
            if let courseDetail = vm.courseDetail,  courseDetail.isEventActive {
                CourseTitleChip(isEvent: true, challengeStatus: .ended, endedAt: "")
            }
            Spacer()
        }
        .padding(.horizontal, 12)
    }
}
