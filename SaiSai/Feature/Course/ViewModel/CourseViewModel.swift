//
//  CourseViewModel.swift
//  SaiSai
//
//  Created by 이창현 on 7/18/25.
//

import Foundation
import Combine

final class CourseViewModel: ObservableObject {
    @Published var hasReachedSinglePageLast: Bool = true
    @Published var isOnlyOngoing: Bool = true
    @Published var contentInfoList: [CourseContentInfo] = []
    var currentPage: Int = 1
    var filteredStatus: ChallengeStatus? {
        isOnlyOngoing ? .ongoing : nil
    }
    
    let courseService = NetworkService<CourseAPI>()
    
    func fetchData() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                if !hasReachedSinglePageLast { return }
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
    
    func setOnlyOngoing(_ isOnlyOngoing: Bool) {
        Task {
            await initCurrentPage()
            await setOnlyOngoingFilterStatus(isOnlyOngoing)
            await toggleIsLoading(true)
            await removeAllCoursesFromList()
            fetchData()
        }
    }
    
    @MainActor
    private func setCourseList(_ contentInfoList: [CourseContentInfo]) {
        self.contentInfoList += contentInfoList
    }
    
    @MainActor
    private func toggleIsLoading(_ isLoading: Bool) {
        self.hasReachedSinglePageLast = isLoading
    }
    
    @MainActor
    func setOnlyOngoingFilterStatus(_ isOnlyOngoing: Bool) {
        self.isOnlyOngoing = isOnlyOngoing
    }
    
    @MainActor
    func removeAllCoursesFromList() {
        self.contentInfoList.removeAll()
    }
    
    @MainActor
    func initCurrentPage() {
        self.currentPage = 1
    }
}
