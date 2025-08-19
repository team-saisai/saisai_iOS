//
//  MainViewModel.swift
//  SaiSai
//
//  Created by ch on 8/17/25.
//

import Foundation

final class MainViewModel {
    weak var delegate: AppConfigureViewModelDelegate?
    
    init(delegate: AppConfigureViewModelDelegate?) {
        self.delegate = delegate
    }
}
