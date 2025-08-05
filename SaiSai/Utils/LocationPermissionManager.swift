//
//  LocationPermissionManager.swift
//  SaiSai
//
//  Created by 이창현 on 7/23/25.
//

import CoreLocation

@Observable
@MainActor class LocationPermissionManager {
    
    let manager: CLLocationManager
    
    init() {
        self.manager = CLLocationManager()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("디버깅: notDetermined")
            manager.desiredAccuracy = kCLLocationAccuracyBest
            self.manager.requestWhenInUseAuthorization()
        case .denied:
            print("디버깅: denied")
        case .restricted:
            print("디버깅: restricted")
        case .authorizedWhenInUse:
            print("디버깅: authorizedWhenInUse")
            manager.startUpdatingLocation()
        default:
            print("디버깅: default")
        }
    }
}
