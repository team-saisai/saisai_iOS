//
//  CourseViewModel.swift
//  SaiSai
//
//  Created by 이창현 on 7/18/25.
//

import Foundation
import Combine

final class CourseViewModel: ObservableObject {
    @Published var hasReachedLast: Bool = true
    @Published var isOnlyOngoing: Bool = false
    @Published var contentInfoList: [CourseContentInfo] = []
    var currentPage: Int = 1
    var filteredStatus: ChallengeStatus? {
        isOnlyOngoing ? .ongoing : nil
    }
    
    func fetchData() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                if !hasReachedLast { return }
                let courseService = NetworkService<CourseAPI>()
                let courseListResponse = try await courseService.request(.getCoursesList(page: currentPage,
                                                                                         status: filteredStatus),
                                                                         responseDTO: AllCourseListResponse.self)
                currentPage += 1
                await setCourseList(courseListResponse.data.content)
                if courseListResponse.data.last { await toggleIsLoading(false) }
            } catch let error {
                print(error)
                print("코스 리스트 정보 제공 실패")
            }
        }
    }
    
    @MainActor
    private func setCourseList(_ contentInfoList: [CourseContentInfo]) {
        self.contentInfoList += contentInfoList
    }
    
    @MainActor
    func toggleIsLoading(_ isLoading: Bool) {
        self.hasReachedLast = isLoading
    }
}
