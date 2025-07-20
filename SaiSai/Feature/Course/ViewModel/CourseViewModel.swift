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
    @Published var filterList: [ThemeInfo] = ThemeInfo.sampleList
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
    
    func challengeButtonClicked() {
        Task {
            await initCurrentPage()
            await toggleOnlyOngoingFilterStatus()
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
        self.hasReachedLast = isLoading
    }
    
    @MainActor
    func toggleOnlyOngoingFilterStatus() {
        self.isOnlyOngoing.toggle()
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
