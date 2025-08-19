//
//  ToastManager.swift
//  SaiSai
//
//  Created by ch on 8/19/25.
//

import Foundation
import Combine

@MainActor
final class ToastManager {
    
    static let shared: ToastManager = .init()
    
    let toastPublisher: PassthroughSubject<ToastType, Never> = .init()
    
    private init() { }
}
