//
//  CourseDetailView.swift
//  SaiSai
//
//  Created by 이창현 on 7/20/25.
//

import SwiftUI

struct CourseDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let courseName: String
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .background(.red)
        .navigationTitle(courseName)
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
