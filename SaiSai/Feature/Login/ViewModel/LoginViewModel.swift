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
                let data = try await API().login(email: emailText, password: passwordText)
                let accessToken = data.data.accessToken
                let refreshToken = data.data.refreshToken
                
                let aT = KeychainManagerImpl().save(token: "accessToken", forKey: accessToken)
                let rT = KeychainManagerImpl().save(token: "refreshToken", forKey: refreshToken)
                
                if !(aT && rT) {
                    print("DEBUG")
                    print(aT, rT)
                    return
                }
                print("SUCCESS")
                await delegate?.isLoggedIn(true)
            } catch {
                print("로그인 실패 😭")
            }
        }
    }
}

@MainActor
protocol LoginViewModelDelegate: AnyObject {
    func isLoggedIn(_ isLoggedIn: Bool)
}
