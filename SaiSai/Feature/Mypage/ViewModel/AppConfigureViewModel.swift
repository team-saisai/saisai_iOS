//
//  AppConfigureViewModel.swift
//  SaiSai
//
//  Created by ch on 8/16/25.
//

import CoreLocation
import Foundation

final class AppConfigureViewModel: ObservableObject {
    @Published var isLogoutAlertPresented: Bool = false
    @Published var isRemoveAccountAlertPresented: Bool = false
    
    func requestLogout() {
        Task { [weak self] in
            guard let self = self else { return }
            // TODO: - 네트워크 요청
        }
    }
    
    func requestRemoveAccount() {
        Task { [weak self] in
            guard let self = self else { return }
            // TODO: - 네트워크 요청
        }
    }
}

extension AppConfigureViewModel {
    @MainActor
    func setIsLogoutAlertPresented(_ isLogoutAlertPresented: Bool) {
        self.isLogoutAlertPresented = isLogoutAlertPresented
    }
    
    @MainActor
    func setIsRemoveAccountAlertPresented(_ isRemoveAccountAlertPresented: Bool) {
        self.isRemoveAccountAlertPresented = isRemoveAccountAlertPresented
    }
    
    @MainActor
    func removeAlert() {
        if isLogoutAlertPresented {
            isLogoutAlertPresented = false
        }
        if isRemoveAccountAlertPresented {
            isRemoveAccountAlertPresented = false
        }
    }
}
