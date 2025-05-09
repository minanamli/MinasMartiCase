//
//  MainPageViewModel.swift
//  MinasMartiCase
//
//  Created by Mina Namlı on 8.05.2025.
//

import Foundation
import CoreLocation

class MainPageViewModel{
    
    var coordinates: [CLLocationCoordinate2D] = []
    
    let locationManager = LocationManager.shared
    
    init() {
        locationManager.delegate = self
    }
    
    func getCurrentLocation() -> CLLocationCoordinate2D? {
        return locationManager.currentLocation?.coordinate
    }

    func requestPermission() {
        locationManager.requestPermission()
    }
    
    func startTracking() {
        locationManager.startTracking()
    }
    
    func stopTracking() {
        locationManager.stopTracking()
    }
    
    func resetRoute(newLocCoordinate: CLLocationCoordinate2D?) {
        locationManager.resetTracking()
        coordinates.removeAll()
        
        if let coordinate = newLocCoordinate {
            coordinates.append(coordinate)
        }
    }
    
    func saveRoute() {
        let data = coordinates.map { ["lat": $0.latitude, "lng": $0.longitude] }
        UserDefaults.standard.set(data, forKey: "savedRoute")
    }

    func getSavedRoute() -> [CLLocationCoordinate2D] {
        guard let saved = UserDefaults.standard.array(forKey: "savedRoute") as? [[String: Double]] else {
            return []
        }
        return saved.compactMap {
            if let lat = $0["lat"], let lng = $0["lng"] {
                return CLLocationCoordinate2D(latitude: lat, longitude: lng)
            }
            return nil
        }
    }

    func clearSavedRoute() {
        UserDefaults.standard.removeObject(forKey: "savedRoute")
    }

}

extension MainPageViewModel: LocationManagerDelegate {
    func didLocationUpdate(_ coordinate: CLLocationCoordinate2D) {
        coordinates.append(coordinate)
        coordinates.append(coordinate)
        saveRoute()
        NotificationCenter.default.post(name: .didReceiveNewCoordinate, object: nil, userInfo: ["coordinate": coordinate])
    }

}
