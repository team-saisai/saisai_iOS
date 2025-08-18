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
    
    var status: NWPath.Status = .satisfied
    
    private init() { }
    
    func startMonitor() {
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.status = path.status
        }
    }
}
