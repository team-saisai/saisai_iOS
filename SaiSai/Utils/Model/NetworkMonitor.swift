//
//  NetworkMonitor.swift
//  SaiSai
//
//  Created by ch on 8/19/25.
//

import Foundation
import Network

final class NetworkMonitor {
    
    static let shared: NetworkMonitor = .init()
    
    private let monitor: NWPathMonitor = .init()
    
    private init() { }
    
    func startMonitor() {
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied {
                DispatchQueue.main.async {
                    ToastManager.shared.toastPublisher.send(.networkNotdetected)
                }
            }
        }
    }
}
