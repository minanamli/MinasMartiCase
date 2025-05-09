//
//  LocationManager.swift
//  MinasMartiCase
//
//  Created by Mina Namlı on 8.05.2025.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didLocationUpdate(_ coordinate: CLLocationCoordinate2D)
}

final class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?
    
    private var lastRecordedLocation: CLLocation?
    
    var currentLocation: CLLocation? {
        return locationManager.location
    }

    private override init() {
        super.init()
        configureLocationManager()
    }
    
    private func configureLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // hassasiyeti yükselttim ama bataryadan fazla enerji tüketir
        locationManager.distanceFilter = 100
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.pausesLocationUpdatesAutomatically = false // kullanıcı hareketsiz kalırsa konum almayı durduruyor, case isteğine tam uymadığı için kapalı bıraktım açılabilir
        locationManager.allowsBackgroundLocationUpdates = true
    }

    func requestPermission() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func startTracking() {
        locationManager.startUpdatingLocation()
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
    
    func resetTracking() {
        lastRecordedLocation = nil
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        if let lastLoc = lastRecordedLocation {
            let distance = newLocation.distance(from: lastLoc)
            if distance < 100 {return}
        }
        
        lastRecordedLocation = newLocation
        delegate?.didLocationUpdate(newLocation.coordinate)
    }
}
