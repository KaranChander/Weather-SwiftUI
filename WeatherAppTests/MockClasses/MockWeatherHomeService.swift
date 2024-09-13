//
//  MockWeatherHomeService.swift
//  WeatherAppTests
//
//  Created by Karan . on 9/13/24.
//

import XCTest
import Combine
@testable import WeatherApp
import CoreLocation

class MockWeatherHomeService: WeatherHomeServiceProtocol {
    var mockCities: [GeoLocation] = []
    var mockGeoLocations: [GeoLocation] = []
    var mockWeatherDetail: Weather?
    var fetchCitiesCalled = false
    var fetchGeoCodedLocationCalled = false
    var fetchWeatherDetailCalled = false
    
    func fetchCities(cityName: String) -> AnyPublisher<[GeoLocation], Error> {
        fetchCitiesCalled = true
        return Just(mockCities)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchGeoCodedLocation(lat: Double, long: Double) async throws -> [GeoLocation] {
        fetchGeoCodedLocationCalled = true
        return mockGeoLocations
    }
    
    func fetchWeatherDetail(lat: Double, long: Double) async throws -> Weather {
        fetchWeatherDetailCalled = true
        guard let weatherDetail = mockWeatherDetail else {
            throw URLError(.badServerResponse)
        }
        return weatherDetail
    }
}
