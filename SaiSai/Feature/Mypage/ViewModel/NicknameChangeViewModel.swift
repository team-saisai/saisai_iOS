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
    @Published var isInputNicknameValid: Bool? = nil
    @Published var shouldHigihlight: Bool = false
    @Published var isSubtextVisible: Bool = false
    let textFieldMaxLength: Int = 10
    let originalNickname: String
    
    let NicknameChangeSuccessPublisher: PassthroughSubject<Void, Never> = .init()
    
    let myService: NetworkService<MyAPI> = .init()
    
    init(nickname: String) {
        self.nickname = nickname
        self.originalNickname = nickname
    }
    
    func checkIfNicknameExists() {
        _Concurrency.Task { [weak self] in
            guard let self = self else { return }
            do {
                let _ = try await myService.request(
                    .nicknameDuplicateCheck(nickname: nickname),
                    responseDTO: NicknameDuplicateCheckResponseDTO.self
                )
                await notifyDuplicateCheckCompleted(true)
            } catch let error as MoyaError {
                if let statusCode = error.response?.statusCode, statusCode == 400 {
                    await notifyDuplicateCheckCompleted(false)
                } else {
                    // TODO: - normal error handle
                    print("닉네임 중복 확인 실패")
                    print(error)
                }
            } catch {
                print("닉네임 중복 확인 실패")
                print(error)
            }
        }
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
                print("닉네임 변경 실패 😭")
                print(error)
                // TODO: - failure handle
            }
        }
    }
    
    private func notifyDuplicateCheckCompleted(_ success: Bool) async {
        await setIsInputNicknameValid(success ? true : false)
        await setIsSubtextVisible(true)
        await setShouldHighlight(false)
    }
}

extension NicknameChangeViewModel {
    @MainActor
    func setIsInputNicknameValid(_ isInputNicknameValid: Bool?) {
        self.isInputNicknameValid = isInputNicknameValid
    }
    
    @MainActor
    func setShouldHighlight(_ shouldHighlight: Bool) {
        self.shouldHigihlight = shouldHighlight
    }
    
    @MainActor
    func setIsSubtextVisible(_ isSubtextVisible: Bool) {
        self.isSubtextVisible = isSubtextVisible
    }
    
    @MainActor
    func nicknameChangeHandler(oldValue: String, newValue: String) {
        if newValue.count > textFieldMaxLength {
            nickname = oldValue
        }
        
        if oldValue != newValue {
            isInputNicknameValid = nil
            shouldHigihlight = true
            if isSubtextVisible { isSubtextVisible = false }
        }
        
        if newValue.count <= 0 || newValue.count > 10 {
            shouldHigihlight = false
        }
        
        if newValue == originalNickname {
            self.isInputNicknameValid = nil
            self.shouldHigihlight = false
            self.isSubtextVisible = false
        }
    }
    
    @MainActor
    func moveToMypageView() {
        NicknameChangeSuccessPublisher.send()
    }
}
