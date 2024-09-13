//
//  UserManager.swift
//  WeatherApp
//
//  Created by Karan . on 9/13/24.
//

import Foundation


import CoreLocation

class UserManager {
    private let locationKey = "userLocation"
    
    // Save user location
    func saveUserLocation(location: CLLocation) {
        let locationData = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude
        ]
        UserDefaults.standard.set(locationData, forKey: locationKey)
    }
    
    // retrieve the user's location 
    func getUserLocation() -> CLLocation? {
        guard let locationData = UserDefaults.standard.dictionary(forKey: locationKey),
              let latitude = locationData["latitude"] as? CLLocationDegrees,
              let longitude = locationData["longitude"] as? CLLocationDegrees else {
            return nil
        }
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
