//
//  NicknameChangeViewModel.swift
//  SaiSai
//
//  Created by ch on 8/12/25.
//

import Foundation
import Moya

final class NicknameChangeViewModel: ObservableObject {
    
    @Published var nickname: String
    
    let myService: NetworkService<MyAPI> = .init()
    
    init(nickname: String) {
        self.nickname = nickname
    }
    
    func checkIfNicknameExists(_ nickname: String) {
        _Concurrency.Task { [weak self] in
            guard let self = self else { return }
            do {
                let response = try await myService.request(
                    .nicknameDuplicateCheck(nickname: nickname),
                    responseDTO: NicknameDuplicateCheckResponseDTO.self
                )
                // TODO: - success handle
            } catch let error as MoyaError {
                if let statusCode = error.response?.statusCode, statusCode == 400 {
                    // TODO: - duplicate error handle
                } else {
                    // TODO: - normal error handle
                }
            } catch {
                print("")
            }
        }
    }
    
    func changeNickname(_ nickname: String) {
        _Concurrency.Task { [weak self] in
            guard let self = self else { return }
            do {
                let response = try await myService.request(
                    .changeNickname(nickname: nickname),
                    responseDTO: ChangeNicknameResponseDTO.self
                )
                // TODO: - success handle
            } catch {
                print("닉네임 변경 실패 😭")
                print(error)
            }
        }
    }
}
