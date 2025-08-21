//
//  NicknameChangeViewModel.swift
//  SaiSai
//
//  Created by ch on 8/12/25.
//

import Foundation
import Combine
import Moya

final class NicknameChangeViewModel: ObservableObject {
    
    @Published var nickname: String
    let textFieldMaxLength: Int = 7
    let originalNickname: String
    
    var isNicknameLengthValid: Bool {
        nickname.isNicknameLengthValid
    }
    var isNicknameCharactersValid: Bool {
        nickname.isNicknameCharactersValid
    }
    var isEqualToOriginalName: Bool {
        nickname == originalNickname
    }
    var isCompleteButtonOn: Bool {
        !isEqualToOriginalName && isNicknameLengthValid && isNicknameCharactersValid
    }
    
    let nicknameChangeSuccessPublisher: PassthroughSubject<Void, Never> = .init()
    
    let myService: NetworkService<MyAPI> = .init()
    
    init(nickname: String) {
        self.nickname = nickname
        self.originalNickname = nickname
    }
    
    func changeNickname() {
        _Concurrency.Task { [weak self] in
            guard let self = self else { return }
            do {
                let _ = try await myService.request(
                    .changeNickname(nickname: nickname),
                    responseDTO: ChangeNicknameResponseDTO.self
                )
                print("SUCCESS")
                await moveToMypageView()
            } catch {
                print("닉네임 중복 확인 실패")
                print(error)
            }
        }
    }
}

extension NicknameChangeViewModel {
    
    @MainActor
    func nicknameChangeHandler(oldValue: String, newValue: String) {
        if newValue.count > textFieldMaxLength {
            nickname = oldValue
        }
    }
    
    @MainActor
    func moveToMypageView() {
        nicknameChangeSuccessPublisher.send()
    }
}
