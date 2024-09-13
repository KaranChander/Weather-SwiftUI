//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Karan . on 9/13/24.
//

import XCTest
import Combine
@testable import WeatherApp
import CoreLocation

final class WeatherHomeViewModelTests: XCTestCase {

    var viewModel: WeatherHomeViewModel!
    var mockService: MockWeatherHomeService!
    var mockLocationManager: MockLocationManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
       mockService = MockWeatherHomeService()
       mockLocationManager = MockLocationManager()
       viewModel = WeatherHomeViewModel(service: mockService, userManager: UserManager(), locationManager: mockLocationManager)
       cancellables = []
    }
    
    override func tearDown() {
           viewModel = nil
           mockService = nil
           mockLocationManager = nil
           cancellables = nil
           super.tearDown()
       }
       
    func testGeoLocationCodingKeys() {
            let geoLocation = GeoLocation(name: "Boston", lat: 42.3601, lon: -71.0589, country: "US", state: "MA")
            
            let encoder = JSONEncoder()
            let decoder = JSONDecoder()
            
            do {
                let jsonData = try encoder.encode(geoLocation)
                let decodedLocation = try decoder.decode(GeoLocation.self, from: jsonData)
                
                XCTAssertEqual(decodedLocation.name, geoLocation.name)
                XCTAssertEqual(decodedLocation.lat, geoLocation.lat)
                XCTAssertEqual(decodedLocation.lon, geoLocation.lon)
                XCTAssertEqual(decodedLocation.country, geoLocation.country)
                XCTAssertEqual(decodedLocation.state, geoLocation.state)
            } catch {
                XCTFail("GeoLocation encoding/decoding failed: \(error.localizedDescription)")
            }
        }

        func testWeatherDetailDecoding() {
            let jsonString = """
            {
                "id": 800,
                "main": "Clear",
                "description": "clear sky",
                "icon": "01d"
            }
            """
            let jsonData = jsonString.data(using: .utf8)!
            
            do {
                let weatherDetail = try JSONDecoder().decode(WeatherDetail.self, from: jsonData)
                
                XCTAssertEqual(weatherDetail.id, 800)
                XCTAssertEqual(weatherDetail.main, "Clear")
                XCTAssertEqual(weatherDetail.description, "clear sky")
                XCTAssertEqual(weatherDetail.icon, WeatherIcon.clearSkyDay)
            } catch {
                XCTFail("WeatherDetail decoding failed: \(error.localizedDescription)")
            }
        }

        func testWeatherDecoding() {
            let jsonString = """
            {
                "coord": {
                    "lon": -71.0589,
                    "lat": 42.3601
                },
                "weather": [
                    {
                        "id": 800,
                        "main": "Clear",
                        "description": "clear sky",
                        "icon": "01d"
                    }
                ],
                "base": "stations",
                "main": {
                    "temp": 295.15,
                    "feels_like": 294.15,
                    "temp_min": 293.15,
                    "temp_max": 297.15,
                    "pressure": 1013,
                    "humidity": 82,
                    "sea_level": 1013,
                    "grnd_level": 1009
                },
                "visibility": 10000,
                "timezone": -14400,
                "id": 4930956,
                "name": "Boston",
                "cod": 200
            }
            """
            let jsonData = jsonString.data(using: .utf8)!
            
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: jsonData)
                
                XCTAssertEqual(weather.coord.lat, 42.3601)
                XCTAssertEqual(weather.coord.lon, -71.0589)
                XCTAssertEqual(weather.weather.first?.id, 800)
                XCTAssertEqual(weather.weather.first?.main, "Clear")
                XCTAssertEqual(weather.weather.first?.description, "clear sky")
                XCTAssertEqual(weather.weather.first?.icon, WeatherIcon.clearSkyDay)
                XCTAssertEqual(weather.main.temp, 295.15)
                XCTAssertEqual(weather.main.feelsLike, 294.15)
                XCTAssertEqual(weather.main.tempMin, 293.15)
                XCTAssertEqual(weather.main.tempMax, 297.15)
                XCTAssertEqual(weather.main.pressure, 1013)
                XCTAssertEqual(weather.main.humidity, 82)
                XCTAssertEqual(weather.main.seaLevel, 1013)
                XCTAssertEqual(weather.main.grndLevel, 1009)
                XCTAssertEqual(weather.visibility, 10000)
                XCTAssertEqual(weather.timezone, -14400)
                XCTAssertEqual(weather.id, 4930956)
                XCTAssertEqual(weather.name, "Boston")
                XCTAssertEqual(weather.cod, 200)
            } catch {
                XCTFail("Weather decoding failed: \(error.localizedDescription)")
            }
        }

}


