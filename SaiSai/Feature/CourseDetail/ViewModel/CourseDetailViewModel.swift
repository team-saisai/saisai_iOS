//
//  CourseDetailViewModel.swift
//  SaiSai
//
//  Created by 이창현 on 7/20/25.
//

import Foundation

final class CourseDetailViewModel: ObservableObject {
    
    // MARK: - Properties
    let courseId: Int
    @Published var courseDetail: CourseDetailInfo? = nil
    @Published var isSummaryViewFolded: Bool = true
    
    // MARK: - Init
    init(courseId: Int) {
        self.courseId = courseId
    }
    
    func fetchData() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let courseService = NetworkService<CourseAPI>()
                let response = try await courseService.request(
                    .getCourseDetail(courseId: courseId),
                    responseDTO: CourseDetailResponseDTO.self)
                await setCourseDetail(response.data)
            } catch {
                print(error)
                print("코스 디테일 조회 실패😭")
            }
        }
    }
    
    @MainActor
    private func setCourseDetail(_ courseDetail: CourseDetailInfo) {
        self.courseDetail = courseDetail
    }
    
    @MainActor
    func toggleSummaryFoldState() {
        self.isSummaryViewFolded.toggle()
    }
}
