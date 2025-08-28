//
//  CourseHistoryView.swift
//  SaiSai
//
//  Created by ch on 8/17/25.
//

import SwiftUI
import Combine

struct CourseHistoryView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var tabState: TabState
    @StateObject var vm: CourseHistoryViewModel = .init()
    @State var isMenuFolded: Bool = true
    let buttonTappedPublisher: PassthroughSubject<Bool, Never> = .init()
    let isEditingPublisher: PassthroughSubject<Bool, Never> = .init()
    let moveToCourseButtonTappedPublisher: PassthroughSubject<Void, Never> = .init()
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                HStack(spacing: 7.5) {
                    Button {
                        vm.toggleIsNotCompletedOnly()
                    } label: {
                        CourseHistoryCheckbox()
                    }
                    
                    Text("주행 중인 코스만 보기")
                        .font(.pretendard(.medium, size: 13))
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding(.top, 15)
                .padding(.leading, 25)
                
                ScrollView(.vertical, showsIndicators: true) {
                    VStack {
                        if !vm.myRideInfoList.isEmpty {
                            ForEach(vm.myRideInfoList.indices, id: \.self) { index in
                                NavigationLink {
                                    CourseDetailView(
                                        vm: CourseDetailViewModel(
                                            courseId: vm.myRideInfoList[index].courseId)
                                    )
                                    .environmentObject(tabState)
                                } label: {
                                    HStack(spacing: 13.5) {
                                        if vm.isEditing {
                                            Button {
                                                vm.addOrDeleteItemFromIndexToRemove(index)
                                            } label: {
                                                if vm.hasIndexInRemoveList(index) {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .resizable()
                                                        .frame(width: 21, height: 21)
                                                        .foregroundStyle(.customPurple)
                                                        .background {
                                                            Circle().fill(.white)
                                                        }
                                                } else {
                                                    Image(systemName: "checkmark.circle")
                                                        .resizable()
                                                        .frame(width: 21, height: 21)
                                                        .foregroundStyle(.gray70)
                                                }
                                            }
                                        }
                                        
                                        SingleCourseHistoryView(
                                            index: index,
                                            vm: vm,
                                            isEditingPublisher: isEditingPublisher
                                        )
                                    }
                                    .padding(.bottom, 20)
                                }
                                
                            }
                        }
                        
                        if vm.hasReachedSinglePageLast {
                            ProgressView()
                                .onAppear() {
                                    vm.fetchData()
                                    print("Reached ProgressView!")
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 13)
            }
            
            if !isMenuFolded {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isMenuFolded = true
                        }
                    }
            }
            
            VStack {
                HStack {
                    Spacer()
                    HistoryDropDown(
                        isFolded: $isMenuFolded,
                        optionPublisher: vm.optionPublisher,
                        tappedOutsidePublisher: vm.tappedoutsidePublisher
                    )
                }
                .padding(.horizontal, 22)
                Spacer()
            }
            .padding(.top, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .zIndex(1)
            
            if vm.isEditing {
                VStack {
                    Spacer()
                    HStack {
                        Text("\(vm.indexSetToRemove.count)개 선택")
                            .font(.pretendard(.medium, size: 16))
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Button {
                            vm.setIsAlertPresented(true)
                        } label: {
                            Text("선택 삭제")
                                .font(.pretendard(.medium, size: 14))
                                .foregroundStyle(.destructiveRed)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 18.5)
                    .padding(.bottom, 50)
                    .background(.gray80)
                }
                .ignoresSafeArea(.all)
            }
            
            if vm.isRequesting {
                VStack {
                    ProgressView()
                        .opacity(0.7)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.gray5.opacity(0.05))
            }
            
            if vm.isAlertPresented {
                Color.gray30.opacity(0.1)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            vm.setIsAlertPresented(false)
                        }
                    }
                
                CustomTwoButtonAlert(
                    buttonTitleText: "\(vm.indexSetToRemove.count)개의 코스를 삭제하겠습니까?",
                    buttonMessageText: "삭제 후에는 복구할 수 없습니다.",
                    buttonText: "삭제",
                    isAction: true,
                    buttonTappedPublisher: buttonTappedPublisher
                )
            }
            
            if vm.myRideInfoList.isEmpty && !vm.hasReachedSinglePageLast {
                EmptyCourseListView(
                    messageText: "주행한 코스가 없습니다.",
                    moveToCourseButtonTappedPublisher: moveToCourseButtonTappedPublisher
                )
                .ignoresSafeArea(.all)
            }
        }
        .onReceive(buttonTappedPublisher, perform: {
            if $0 {
                vm.requestRemoveMultipleHistory()
            }
            withAnimation(.easeInOut) {
                vm.setIsAlertPresented(false)
            }
        })
        .onReceive(moveToCourseButtonTappedPublisher, perform: {
            self.presentationMode.wrappedValue.dismiss()
            tabState.selectedTab = 1
        })
        .onReceive(vm.optionPublisher) { option in
            vm.setSortOption(option)
        }
        .onChange(of: vm.isEditing, { _, newValue in
            isEditingPublisher.send(newValue)
        })
        .onChange(of: vm.isNotCompletedOnly, { oldValue, newValue in
            vm.refreshList()
        })
        .background(.gray90)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("코스 기록\(vm.isEditing ? " 편집" : "")")
                    .font(.pretendard(.semibold, size: 16))
                    .foregroundColor(.white)
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
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
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if !vm.myRideInfoList.isEmpty {
                    Button {
                        withAnimation(.easeInOut) {
                            if vm.isEditing {
                                vm.resetIndexToRemove()
                            }
                            vm.toggleIsEditing()
                        }
                    } label: {
                        Text(vm.isEditing ? "완료" : "편집")
                            .font(.pretendard(size: 14))
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }
}

extension CourseHistoryView {
    @ViewBuilder
    private func CourseHistoryCheckbox() -> some View {
        Image(systemName: vm.isNotCompletedOnly ? "checkmark.square.fill" : "square")
            .resizable()
            .frame(width: 13.2, height: 13.2)
            .foregroundStyle(vm.isNotCompletedOnly ? .customLightPurple : .white)
            .background(
                RoundedRectangle(cornerRadius: 10)
                .fill(vm.isNotCompletedOnly ? .white : .clear))
    }
}

struct HistoryDropDown: View {
    
    @State var selectedOption: HistorySortOption = .newest
    @Binding var isFolded: Bool
    
    let optionPublisher: PassthroughSubject<HistorySortOption, Never>
    let tappedOutsidePublisher: PassthroughSubject<Void, Never>
    
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
                    ForEach(HistorySortOption.allCases, id: \.self) { option in
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
                .frame(width: 70)
                .overlay {
                    RoundedRectangle(cornerRadius: 8).stroke(Color.gray40, lineWidth: 1)
                }
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.menuItemDefaultBg))
            }
        }
        .font(.pretendard(.regular, size: 13))
        .onReceive(tappedOutsidePublisher) {
            isFolded = true
        }
    }
}
