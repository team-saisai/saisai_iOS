//
//  CourseHistoryViewModel.swift
//  SaiSai
//
//  Created by ch on 8/17/25.
//

import Foundation
import Combine

final class CourseHistoryViewModel: ObservableObject {
    
    @Published var isEditing: Bool = false
    @Published var hasReachedSinglePageLast: Bool = true
    @Published var myRideInfoList: [MyRidesInfo] = []
    @Published var isRequesting: Bool = false
    @Published var indexSetToRemove = Set<Int>()
    @Published var isAlertPresented: Bool = false
    @Published var isNotCompletedOnly: Bool = true
    let optionPublisher: PassthroughSubject<HistorySortOption, Never> = .init()
    let tappedoutsidePublisher: PassthroughSubject<Void, Never> = .init()
    var selectedOption: HistorySortOption = .newest
    
    var currentPage: Int = 1
    
    let myService: NetworkService<MyAPI> = .init()
    
    func fetchData() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                if !hasReachedSinglePageLast { return }
                let response = try await myService.request(
                    .getMyRides(
                        page: currentPage,
                        sort: selectedOption,
                        notCompletedOnly: isNotCompletedOnly
                    ),
                    responseDTO: MyRidesResponseDTO.self
                )
                currentPage += 1
                await setCourseList(response.data.content)
                if response.data.last { await toggleIsLoading(false) }
            } catch {
                await setIsRequesting(false)
                print("코스 기록 불러오기 실패")
                print(error)
            }
        }
    }
    
    func requestRemoveMultipleHistory() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                await setIsRequesting(true)
                var rideIds: [Int] = []
                indexSetToRemove.forEach {
                    rideIds.append(self.myRideInfoList[$0].rideId)
                }
                let _ = try await myService.request(
                    .deleteMyRides(rideIds: rideIds),
                    responseDTO: MyRidesDeleteResponseDTO.self
                )
                refreshList()
            } catch {
                await setIsRequesting(false)
                print("코스 기록 삭제 실패")
                print(error)
            }
        }
    }
    
    func hasIndexInRemoveList(_ index: Int) -> Bool {
        return indexSetToRemove.contains(index)
    }
    
    func refreshList() {
        Task {
            [weak self] in
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
    
    func setSortOption(_ selectedOption: HistorySortOption) {
        Task { [weak self] in
            guard let self = self else { return }
            await initCurrentPage()
            await setSelectedOption(selectedOption)
            await toggleIsLoading(true)
            await removeAllCoursesFromList()
            fetchData()
        }
    }
}

extension CourseHistoryViewModel {
    @MainActor
    func toggleIsEditing() {
        self.isEditing.toggle()
    }
    
    @MainActor
    func setIsEditing(_ isEditing: Bool) {
        self.isEditing = isEditing
    }
    
    @MainActor
    private func setCourseList(_ contentInfoList: [MyRidesInfo]) {
        self.myRideInfoList += contentInfoList
    }
    
    @MainActor
    func toggleIsLoading(_ isLoading: Bool) {
        self.hasReachedSinglePageLast = isLoading
    }
    
    @MainActor
    func setIsRequesting(_ isRequesting: Bool) {
        self.isRequesting = isRequesting
    }
    
    @MainActor
    func removeAllCoursesFromList() {
        self.myRideInfoList.removeAll()
    }
    
    @MainActor
    func initCurrentPage() {
        self.currentPage = 1
    }
    
    @MainActor
    func addIndexToRemove(_ index: Int) {
        self.indexSetToRemove.insert(index)
    }
    
    @MainActor
    func deleteFromIndexToRemove(_ index: Int) {
        if indexSetToRemove.contains(index) {
            self.indexSetToRemove.remove(index)
        }
    }
    
    @MainActor
    func addOrDeleteItemFromIndexToRemove(_ index: Int) {
        indexSetToRemove.contains(index) ? deleteFromIndexToRemove(index) : addIndexToRemove(index)
    }
    
    @MainActor
    func resetIndexToRemove() {
        self.indexSetToRemove.removeAll()
    }
    
    @MainActor
    func removeItemFromContentInfoList(_ index: Int) {
        self.myRideInfoList.remove(at: index)
    }
    
    @MainActor
    func setIsAlertPresented(_ isAlertPresented: Bool) {
        self.isAlertPresented = isAlertPresented
    }
    
    @MainActor
    func toggleIsNotCompletedOnly() {
        self.isNotCompletedOnly.toggle()
    }
    
    @MainActor
    func setSelectedOption(_ selectedOption: HistorySortOption) {
        self.selectedOption = selectedOption
    }
}
