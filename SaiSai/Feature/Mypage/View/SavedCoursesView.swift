//
//  SavedCoursesView.swift
//  SaiSai
//
//  Created by ch on 8/17/25.
//

import SwiftUI
import Combine

struct SavedCoursesView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var tabState: TabState
    @StateObject var vm: SavedCoursesViewModel = .init()
    let buttonTappedPublisher: PassthroughSubject<Bool, Never> = .init()
    let isEditingPublisher: PassthroughSubject<Bool, Never> = .init()
    let moveToCourseButtonTappedPublisher: PassthroughSubject<Void, Never> = .init()
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    if !vm.contentInfoList.isEmpty {
                        ForEach(vm.contentInfoList.indices, id: \.self) { index in
                            NavigationLink {
                                CourseDetailView(
                                    vm: CourseDetailViewModel(
                                        courseId: vm.contentInfoList[index].courseId)
                                )
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
                                    
                                    SingleSavedCourseView(
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
            .padding(.top, 10)
            
            if vm.isEditing {
                VStack {
                    Spacer()
                    HStack {
                        Text("\(vm.indexListToRemove.count)개 선택")
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
                    buttonTitleText: "\(vm.indexListToRemove.count)개의 코스를 삭제하겠습니까?",
                    buttonMessageText: "삭제 후에는 복구할 수 없습니다.",
                    buttonText: "삭제",
                    isAction: true,
                    buttonTappedPublisher: buttonTappedPublisher
                )
            }
            
            if vm.contentInfoList.isEmpty {
                EmptyCourseListView(
                    messageText: "저장한 코스가 없습니다.",
                    moveToCourseButtonTappedPublisher: moveToCourseButtonTappedPublisher
                )
                .ignoresSafeArea(.all)
            }
        }
        .onReceive(buttonTappedPublisher, perform: {
            if $0 {
                vm.requestRemoveMultipleBookmarks()
            }
            withAnimation(.easeInOut) {
                vm.setIsAlertPresented(false)
            }
        })
        .onReceive(moveToCourseButtonTappedPublisher, perform: {
            self.presentationMode.wrappedValue.dismiss()
            tabState.selectedTab = 1
        })
        .onChange(of: vm.isEditing, { _, newValue in
            isEditingPublisher.send(newValue)
        })
        .background(.gray90)
        .navigationTitle("저장한 코스\(vm.isEditing ? " 편집" : "")")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
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
                if !vm.contentInfoList.isEmpty {
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
