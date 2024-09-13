//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Karan . on 9/13/24.
//

import Foundation
import CoreLocation
import Combine

protocol LocationManagerProtocol {
    var userLocationPublisher: AnyPublisher<CLLocation?, Never> { get }
    func requestLocationPermission()
}

class LocationManager: NSObject, CLLocationManagerDelegate, LocationManagerProtocol {
    
    // MARK: - Properties
    var userLocationPublisher: AnyPublisher<CLLocation?, Never> {
        return userLocationSubject.eraseToAnyPublisher()
    }
    
    private var userLocationSubject = CurrentValueSubject<CLLocation?, Never>(nil)

    private let locationManager = CLLocationManager()
    private let userManager:  UserManager

    
    // MARK: - Methods
    init(userManager: UserManager) {
        self.userManager = userManager
        super.init()
        self.locationManager.delegate = self
    }
    
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
           let status = manager.authorizationStatus
           
           switch status {
           case .notDetermined:
               print(" Not determined")
               requestLocationPermission()
               
           case .restricted, .denied:
               print("restricted or denied")
               
           case .authorizedWhenInUse, .authorizedAlways:
               print("Authorization granted")
               startUpdatingLocation()
               
           default:
               print("Unhandled authorization status")
           }
       }
       
       private func startUpdatingLocation() {
               locationManager.startUpdatingLocation()
       }
       
    // MARK: - Location Manager Delegate

       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           guard let location = locations.last else { return }
           userLocationSubject.send(location)
           userManager.saveUserLocation(location: location) // Save the location
       }
}


