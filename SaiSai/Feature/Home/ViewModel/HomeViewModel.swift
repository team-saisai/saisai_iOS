//
//  HomeViewModel.swift
//  SaiSai
//
//  Created by 이창현 on 7/8/25.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published var name: String = "델라"
    @Published var isRecentRideExists: Bool = false
    @Published var popularCourses: [CourseInfo] = []
    
    func fetchData() {
    }
}
