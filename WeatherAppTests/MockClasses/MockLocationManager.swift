//
//  MockLocationManager.swift
//  WeatherAppTests
//
//  Created by Karan . on 9/13/24.
//

import XCTest
import Combine
@testable import WeatherApp
import CoreLocation


class MockLocationManager: LocationManagerProtocol {

    private let userLocationSubject = PassthroughSubject<CLLocation?, Never>()
    
    var userLocationPublisher: AnyPublisher<CLLocation?, Never> {
        return userLocationSubject.eraseToAnyPublisher()
    }
    
    func requestLocationPermission() {
        print("Mock: Requesting location permission")
    }
    
    func simulateLocationUpdate(_ location: CLLocation?) {
        userLocationSubject.send(location)
    }
    
    func simulateNoPermission() {
        print("Mock: Location permission denied")
    }
}
