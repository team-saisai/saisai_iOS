//
//  SavedCoursesViewModel.swift
//  SaiSai
//
//  Created by ch on 8/17/25.
//

import Foundation

final class SavedCoursesViewModel: ObservableObject {
    @Published var isEditing: Bool = false
    @Published var hasReachedSinglePageLast: Bool = true
    @Published var contentInfoList: [CourseContentInfo] = []
    @Published var isRequesting: Bool = false
    @Published var indexListToRemove = Set<Int>()
    @Published var isAlertPresented: Bool = false
    
    var currentPage: Int = 1
    
    let myService = NetworkService<MyAPI>()
    let courseService = NetworkService<CourseAPI>()
    
    func fetchData() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                if !hasReachedSinglePageLast { return }
                let courseListResponse = try await myService.request(
                    .getMyBookmarkedCourses(page: currentPage),
                    responseDTO: MyBookmarkedCoursesResponseDTO.self
                )
                currentPage += 1
                await setCourseList(courseListResponse.data.content)
                if courseListResponse.data.last { await toggleIsLoading(false) }
            } catch {
                print(error)
                print("저장된 코스 리스트 정보 제공 실패")
            }
        }
    }
    
    func requestSingleBookmark(courseId: Int, index: Int) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                await setIsRequesting(true)
                let _ = try await courseService.request(
                    .deleteBookmark(courseId: courseId),
                    responseDTO: BookmarkResponseDTO.self
                )
                await removeItemFromContentInfoList(index)
                await setIsRequesting(false)
            } catch {
                await setIsRequesting(false)
                print("북마크 상태 변경 실패 🥲")
                print(error)
            }
        }
    }
    
    func requestRemoveMultipleBookmarks() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                await setIsRequesting(true)
                var courseIds: [Int] = []
                indexListToRemove.forEach {
                    courseIds.append(self.contentInfoList[$0].courseId)
                }
                let _ = try await myService.request(
                    .deleteBookmarkedCourses(courseIds: courseIds),
                    responseDTO: MyBookmarkedCoursesDeleteResponseDTO.self
                )
                refreshList()
            } catch {
                await setIsRequesting(false)
                print("복수 북마크 제거 실패 🥲")
                print(error)
            }
        }
    }
    
    private func refreshList() {
        Task { [weak self] in
            guard let self = self else { return }
            await toggleIsLoading(true)
            await setIsRequesting(true)
            await removeAllCoursesFromList()
            await initCurrentPage()
            if isEditing == true { await setIsEditing(false) }
            await resetIndexToRemove()
            await setIsRequesting(false)
            fetchData()
        }
    }
    
    func hasIndexInRemoveList(_ index: Int) -> Bool {
        return indexListToRemove.contains(index)
    }
}

extension SavedCoursesViewModel {
    @MainActor
    private func setIsEditing(_ isEditing: Bool) {
        self.isEditing = isEditing
    }
    
    @MainActor
    func toggleIsEditing() {
        self.isEditing.toggle()
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
    func setIsRequesting(_ isRequesting: Bool) {
        self.isRequesting = isRequesting
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
    func addIndexToRemove(_ index: Int) {
        self.indexListToRemove.insert(index)
    }
    
    @MainActor
    func deleteFromIndexToRemove(_ index: Int) {
        if indexListToRemove.contains(index) {
            self.indexListToRemove.remove(index)
        }
    }
    
    @MainActor
    func addOrDeleteItemFromIndexToRemove(_ index: Int) {
        indexListToRemove.contains(index) ? deleteFromIndexToRemove(index) : addIndexToRemove(index)
    }
    
    @MainActor
    func resetIndexToRemove() {
        self.indexListToRemove.removeAll()
    }
    
    @MainActor
    func removeItemFromContentInfoList(_ index: Int) {
        self.contentInfoList.remove(at: index)
    }
    
    @MainActor
    func setIsAlertPresented(_ isAlertPresented: Bool) {
        self.isAlertPresented = isAlertPresented
    }
}
