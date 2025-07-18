//
//  CourseViewModel.swift
//  SaiSai
//
//  Created by 이창현 on 7/18/25.
//

import Foundation

final class CourseViewModel: ObservableObject {
    @Published var contentInfoList: [CourseContentInfo] = []
    
    func fetchData() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let courseService = NetworkService<CourseAPI>()
                let courseListResponse = try await courseService.request(.getCoursesList(), responseDTO: AllCourseListResponse.self)
                await setCourseList(courseListResponse.data.content)
            } catch let error {
                print(error)
                print("코스 리스트 정보 제공 실패")
            }
        }
    }
    
    @MainActor
    private func setCourseList(_ contentInfoList: [CourseContentInfo]) {
        self.contentInfoList = contentInfoList
    }
}
