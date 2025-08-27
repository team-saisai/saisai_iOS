//
//  JoinViewModel.swift
//  SaiSai
//
//  Created by ch on 8/20/25.
//

import Foundation
import Moya

final class JoinViewModel: ObservableObject {
    
    @Published var isAlertPresented: Bool = false
    @Published var isUseAndPrivacyTermsChecked: Bool = false
    @Published var isAgeTermsChecked: Bool = false
    var isAllChecked: Bool {
        return isUseAndPrivacyTermsChecked && isAgeTermsChecked
    }
    
    let authService: NetworkService<AuthAPI> = .init()
    
    func getToken() -> String {
        switch OAuthTokenStore.shared.provider {
        case .apple: OAuthTokenStore.shared.appleToken
        case .google: OAuthTokenStore.shared.googleToken
        case .kakao: OAuthTokenStore.shared.kakaoToken
        }
    }
}

extension JoinViewModel {
    @MainActor
    func toggleIsUseAndPrivacyTerms() {
        isUseAndPrivacyTermsChecked.toggle()
    }
    
    @MainActor
    func toggleIsAgeTermsChecked() {
        isAgeTermsChecked.toggle()
    }
    
    @MainActor
    func setIsAlertPresented(_ isPresented: Bool) {
        isAlertPresented = isPresented
    }
    
    @MainActor
    func setIsUseAndPrivacyTermsChecked(_ isChecked: Bool) {
        isUseAndPrivacyTermsChecked = isChecked
    }
    
    @MainActor
    func setIsAgeTermsChecked(_ isChecked: Bool) {
        isAgeTermsChecked = isChecked
    }
    
    @MainActor
    func setToAllOrNone() {
        let allchecked = isAllChecked
        isAgeTermsChecked = !allchecked
        isUseAndPrivacyTermsChecked = !allchecked
    }
}
