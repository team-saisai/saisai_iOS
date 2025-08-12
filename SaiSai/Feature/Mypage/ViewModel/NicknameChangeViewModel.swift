//
//  NicknameChangeViewModel.swift
//  SaiSai
//
//  Created by ch on 8/12/25.
//

import Foundation

final class NicknameChangeViewModel: ObservableObject {
    
    @Published var nickname: String
    
    init(nickname: String) {
        self.nickname = nickname
    }
}
