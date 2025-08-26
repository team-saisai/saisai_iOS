//
//  CourseDetailView.swift
//  SaiSai
//
//  Created by 이창현 on 7/20/25.
//

import SwiftUI
import UIKit

struct CourseDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var tabState: TabState
    @StateObject var vm: CourseDetailViewModel
    
    var body: some View {
        ZStack {
            VStack {
                CourseRidingView(vm: vm)
            }
            
            VStack(spacing: 8) {
                if vm.rideId != nil {
                    VStack {
                        TimerView(vm: vm)
                    }
                    .padding(.top, 14)
                }
                
                Spacer()
                
                if vm.rideId != nil {
                    Button {
                        withAnimation {
                            vm.toggleIsRidingCourseSummaryFolded()
                        }
                    } label: {
                        if vm.isRidingCourseSummaryFolded {
                            RenderRidingCourseSummaryButton()
                        } else {
                            RidingCourseSummaryView()
                        }
                    }
                    RidingStatusBottomItem(vm: vm)
                } else {
                    CourseTitleChipsView()
                    CourseDetailBottomItem(vm: vm)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 18)
            .padding(.bottom, 42)
            
            
            
            if vm.isAlertPresented {
                Color.black.opacity(0.001)
                    .onTapGesture {
                        vm.removeAlert()
                    }
            }
            
            if vm.isUserLocationAllowAlertPresented {
                CustomTwoButtonAlert(buttonTitleText: "위치 권한이 필요합니다. 설정에서 변경해주세요.",
                                     buttonText: "설정으로 이동",
                                     isAction: true,
                                     buttonTappedPublisher: vm.userLocationAlertButtonTappedPublisher
                )
            }
            
            if vm.isCancelAlertPresented {
                CustomTwoButtonAlert(
                    buttonTitleText: "코스를 중단하고 나가시겠습니까?",
                    buttonMessageText: "코스는 홈에서 이어서 도전할 수 있습니다.",
                    buttonText: "나가기",
                    isAction: true,
                    buttonTappedPublisher: vm.cancelAlertButtonTappedPublisher)
            }
            
            if vm.isInstructionAlertPresented {
                CourseRidingInstructionView(
                    startButtonOnInstructionPublisher: vm.startButtonOnInstructionPublisher
                )
                .padding(.horizontal, 35)
            }
            
            if vm.isToastPresented {
                VStack {
                    ToastView()
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            vm.isUserLocationAvailable()
            vm.fetchData()
        }
        .onDisappear() {
            vm.exitTimer()
        }
        .navigationDestination(isPresented: $vm.isCompleted) {
            CourseCompleteView(vm: vm)
                .environmentObject(tabState)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray20)
        .navigationTitle(vm.courseDetail?.courseName ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    if vm.hasUncompletedRide && !vm.isPaused && !vm.isAlertPresented {
                        vm.setIsCancelAlertPresented(true)
                    } else {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .frame(width: 10, height: 20)
                    }
                    .padding(.horizontal, 8)
                }
            }
        }
        .onReceive(vm.cancelAlertButtonTappedPublisher) {
            vm.setIsCancelAlertPresented(false)
            if $0 {
                vm.requestPauseRiding()
                presentationMode.wrappedValue.dismiss()
            }
        }
        .onReceive(vm.userLocationAlertButtonTappedPublisher) {
            vm.setIsUserLocationAlertPresented(false)
            self.presentationMode.wrappedValue.dismiss()
            if $0 {
                openAppSettings()
            }
        }
    }
}

extension CourseDetailView {
    @ViewBuilder
    private func CourseTitleChipsView() -> some View {
        HStack(spacing: 4) {
            if let status = vm.courseDetail?.challengeStatusCase {
                CourseTitleChip(
                    challengeStatus: status,
                    endedAt: vm.courseDetail?.challengeEndedAt ?? "")
            }
            if let courseDetail = vm.courseDetail, let isEventActive = courseDetail.isEventActive, isEventActive {
                CourseTitleChip(
                    isEvent: true,
                    challengeStatus: .ended,
                    endedAt: ""
                )
            }
            Spacer()
        }
        .padding(.horizontal, 12)
    }
}

extension CourseDetailView {
    @ViewBuilder
    private func RidingCourseSummaryView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(vm.courseDetail?.courseName ?? "")
                .font(.pretendard(.semibold, size: 16))
                .padding(.bottom, 5)
            
            HStack(spacing: 5) {
                Text("\(String(format: "%.1f", vm.courseDetail?.distance ?? 0.0))km")
                Text("·")
                LevelView(level: vm.courseDetail?.level ?? 0)
            }
            .font(.pretendard(.medium, size: 11))
            .foregroundStyle(.gray40)
            .padding(.bottom, 14)
            
            Text(vm.courseDetail?.convertedSummary ?? "")
                .font(.pretendard(size: 14))
                .multilineTextAlignment(.leading)
//                .lineLimit(0)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .foregroundStyle(.white)
        .background(RoundedRectangle(cornerRadius: 16).fill(.courseDetailBg.opacity(0.85)))
    }
    
    @ViewBuilder
    private func RenderRidingCourseSummaryButton() -> some View {
        HStack {
            HStack(spacing: 9) {
                Image(.icForkRight)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 11, height: 14.8)
                
                Text("경로 소개")
                    .font(.pretendard(.medium, size: 13))
                
            }
            .foregroundStyle(.white)
            .padding(.vertical, 9)
            .padding(.horizontal, 14)
            .background(RoundedRectangle(cornerRadius: 40).fill(.courseDetailBg))
            
            Spacer()
        }
    }
}

extension CourseDetailView {
    @ViewBuilder
    private func ToastView() -> some View {
        HStack(spacing: 5) {
            Image(systemName: vm.toastType.imageText)
                .foregroundStyle(vm.toastType.imageColor)
            
            Text(vm.toastType.toastText)
                .font(.pretendard(size: 12))
                .foregroundStyle(.gray90)
            
            Spacer()
            
            Button {
                withAnimation {
                    vm.setIsToastPresented(false)
                }
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.gray90)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(.white))
    }
}

extension CourseDetailView {
    private func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
