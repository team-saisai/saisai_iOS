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
    @Published var isChallengeSelected: Bool = true
    @Published var contentInfoList: [CourseContentInfo] = []
    @Published var isRequestingBookmarks: Bool = false
    @Published var selectedOption: CourseSortOption = .levelAsc
    let optionPublisher: PassthroughSubject<CourseSortOption, Never> = .init()
    let tappedoutsidePublisher: PassthroughSubject<Void, Never> = .init()
    var currentPage: Int = 1
    
    let courseService = NetworkService<CourseAPI>()
    
    func fetchData() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                if !hasReachedSinglePageLast { return }
                let courseListResponse = try await courseService.request(
                    .getCoursesList(
                        page: currentPage,
                        isChallenge: isChallengeSelected,
                        sort: selectedOption
                    ),
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
    
    func requestBookmark(courseId: Int, index: Int, pastValue: Bool) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                await setIsRequestingBookmarks(true)
                if pastValue { // 북마크 해제 요청
                    let response = try await courseService.request(
                        .deleteBookmark(courseId: courseId),
                        responseDTO: BookmarkResponseDTO.self
                    )
                    await toggleBookmarkState(index, response.data.isCourseBookmarked)
                } else { // 북마크 등록 요청
                    let response = try await courseService.request(
                        .saveBookmark(courseId: courseId),
                        responseDTO: BookmarkResponseDTO.self)
                    await toggleBookmarkState(index, response.data.isCourseBookmarked)
                }
                await setIsRequestingBookmarks(false)
            } catch {
                await setIsRequestingBookmarks(false)
                print("북마크 상태 변경 실패 🥲")
            }
        }
    }
    
    func setOnlyOngoing(_ isOnlyOngoing: Bool) {
        Task { [weak self] in
            guard let self = self else { return }
            await initCurrentPage()
            await setOnlyOngoingFilterStatus(isOnlyOngoing)
            await toggleIsLoading(true)
            await removeAllCoursesFromList()
            fetchData()
        }
    }
    
    func setSortOption(_ selectedOption: CourseSortOption) {
        Task { [weak self] in
            guard let self = self else { return }
            await initCurrentPage()
            await setSelectedOption(selectedOption)
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
        self.isChallengeSelected = isOnlyOngoing
    }
    
    @MainActor
    func removeAllCoursesFromList() {
        self.contentInfoList.removeAll()
    }
    
    @MainActor
    func initCurrentPage() {
        self.currentPage = 1
    }
    
    @MainActor
    func toggleBookmarkState(_ index: Int, _ isBookmarked: Bool) {
        if contentInfoList.count <= index { return }
        self.contentInfoList[index].isBookmarked = isBookmarked
    }
    
    @MainActor
    func setIsRequestingBookmarks(_ isRequestingBookmarks: Bool) {
        self.isRequestingBookmarks = isRequestingBookmarks
    }
    
    @MainActor
    func setSelectedOption(_ selectedOption: CourseSortOption) {
        self.selectedOption = selectedOption
    }
}
