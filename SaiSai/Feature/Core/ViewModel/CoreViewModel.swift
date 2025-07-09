//
//  CoreViewModel.swift
//  SaiSai
//
//  Created by ch on 7/9/25.
//

import Foundation

final class CoreViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
}

@MainActor
extension CoreViewModel: LoginViewModelDelegate {
    func isLoggedIn(_ isLoggedIn: Bool) {
        self.isLoggedIn = isLoggedIn
    }
}
