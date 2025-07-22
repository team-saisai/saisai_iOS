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
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
            
            VStack {
                Spacer()
                
                withAnimation(.easeInOut(duration: 0.3)) {
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
        .ignoresSafeArea(.all)
        .background(.red)
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
