//
//  LoginViewModel.swift
//  SaiSai
//
//  Created by ch on 7/9/25.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    
    weak var delegate: LoginViewModelDelegate?
    
    init(delegate: LoginViewModelDelegate) {
        self.delegate = delegate
    }
    
    func requestLogin() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let service = NetworkService<AuthAPI>()
                let response = try await service.request(
                    .login(email: emailText, password: passwordText),
                    responseDTO: LoginResponseDTO.self)
                
                let accessToken = response.data.accessToken
                let refreshToken = response.data.refreshToken
                saveTokens(accessToken: accessToken, refreshToken: refreshToken)
                
                await delegate?.isLoggedIn(true)
            } catch {
                // TODO: - Alert logic 추가
                print("로그인 실패😣")
            }
        }
    }
    
    private func saveTokens(accessToken: String, refreshToken: String) {
        let keychainManager = KeychainManagerImpl()
        let _ = keychainManager.save(token: accessToken, forKey: HTTPHeaderField.accessToken.rawValue)
        let _ = keychainManager.save(token: refreshToken, forKey: HTTPHeaderField.refreshToken.rawValue)
    }
}

@MainActor
protocol LoginViewModelDelegate: AnyObject {
    func isLoggedIn(_ isLoggedIn: Bool)
}
