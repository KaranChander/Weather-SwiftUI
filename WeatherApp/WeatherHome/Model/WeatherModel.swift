//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Karan . on 9/13/24.
//

import Foundation

struct Weather: Codable {
    let coord: Coord
    let weather: [WeatherDetail]
    let base: String
    let main: Main
    let visibility: Int
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int
    var displayTemp: String {
        return "\(Int(temp - 273.15) )°C"
    }
    var displayHighTemp: String{
        return "\(Int(tempMax - 273.15))°C"
    }
    var displayLowTemp: String{
        return "\(Int(tempMin - 273.15))°C"
    }

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Weather
struct WeatherDetail: Codable {
    let id: Int
    let main, description: String
    let icon: WeatherIcon?
}

enum WeatherIcon: String, Codable {
    case clearSkyDay = "01d"
    case clearSkyNight = "01n"
    case fewCloudsDay = "02d"
    case fewCloudsNight = "02n"
    case scatteredCloudsDay = "03d"
    case scatteredCloudsNight = "03n"
    case brokenCloudsDay = "04d"
    case brokenCloudsNight = "04n"
    case showerCloudsDay = "09d"
    case showerCloudsNight = "09n"
    case rainDay = "10d"
    case rainNight = "10n"
    case thunderStormDay = "11d"
    case thunderStormNight = "11n"
    case snowDay = "13d"
    case snowNight = "13n"
    case mistDay = "50d"
    case mistNight = "50n"
}



struct GeoLocation: Codable, Identifiable {
    let id = UUID()
    let name: String
    let lat, lon: Double
    let country, state: String?

    enum CodingKeys: String, CodingKey {
        case name
        case lat, lon, country, state
    }
}
