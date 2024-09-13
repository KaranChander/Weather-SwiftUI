//
//  WeatherHomeService.swift
//  WeatherApp
//
//  Created by Karan . on 9/13/24.
//

import Foundation
import Combine

protocol WeatherHomeServiceProtocol {
    func fetchCities(cityName: String) -> AnyPublisher<[GeoLocation], Error>
    func fetchGeoCodedLocation(lat: Double, long: Double) async throws -> [GeoLocation]
    func fetchWeatherDetail(lat: Double, long: Double) async throws -> Weather
}

public class WeatherHomeService: WeatherHomeServiceProtocol {
    
    private var cancellables = Set<AnyCancellable>()

    
    func fetchWeatherDetail(lat: Double, long: Double) async throws -> Weather {
        
        let queryItems = [URLQueryItem(name: "lat", value: String(lat)),
                        URLQueryItem(name: "lon", value: String(long)),
                        URLQueryItem(name: "appid", value: APIRequestManager().getAPIKey())]

        //I wouldve also created wrapper for the paths
        guard let urlRequest = WeatherHomeEndPoint.init(path: "/data/2.5/weather", queryItems: queryItems).request else {
            throw  NSError(domain: "Failed create request", code: 400)
        }
        
        do {
            // Perform the network request
            print(urlRequest)
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            
            //if i had more time then i would've created enum wrapper for error and handled error in a better way
            
            do {
                    let weatherDetail = try JSONDecoder().decode(Weather.self, from: data)
                    return weatherDetail
              
            } catch {
                throw NSError(domain: "Failed to parse json object", code: 300)
            }
            
        } catch {
            throw URLError(.badServerResponse)
        }
    }
    
    
    func fetchGeoCodedLocation(lat: Double, long: Double) async throws -> [GeoLocation] {
        let queryItems = constructQueryItems(latitude: lat, longitude: long)

        //I wouldve also created wrapper for the paths
        guard let urlRequest = WeatherHomeEndPoint.init(path: "/geo/1.0/reverse", queryItems: queryItems).request else {
            throw  NSError(domain: "Failed create request", code: 400)
        }
        
        do {
            // Perform the network request
            print(urlRequest)
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            
            //if i had more time then i would've created enum wrapper for error and handled error in a better way
            
            do {
                    let locations = try JSONDecoder().decode([GeoLocation].self, from: data)
                    return locations
              
            } catch {
                throw NSError(domain: "Failed to parse json object", code: 300)
            }
            
        } catch {
            throw URLError(.badServerResponse)
        }
    }
    

    func fetchCities(cityName: String) -> AnyPublisher<[GeoLocation], Error> {
        let queryItems = constructQueryItems(cityName: cityName)

        guard let urlRequest = WeatherHomeEndPoint(path: "/geo/1.0/direct", queryItems: queryItems).request else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { result -> Data in
                guard let httpResponse = result.response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: [GeoLocation].self, decoder: JSONDecoder())
            .mapError { error -> Error in
                return error
            }
            .eraseToAnyPublisher()
    }

    
    
    func constructQueryItems(cityName: String? = nil, latitude: Double? = nil, longitude: Double? = nil) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        
        // Add query items based on whether cityName or lat/lon is available
        if let cityName = cityName, !cityName.isEmpty {
            queryItems.append(URLQueryItem(name: "q", value: cityName))
        }
        
        if let latitude = latitude, let longitude = longitude {
            queryItems.append(URLQueryItem(name: "lat", value: "\(latitude)"))
            queryItems.append(URLQueryItem(name: "lon", value: "\(longitude)"))
        }
        
        // Add common query items like limit and API key
        queryItems.append(URLQueryItem(name: "limit", value: "5"))
        queryItems.append(URLQueryItem(name: "appid", value: APIRequestManager().getAPIKey()))
        
        return queryItems
    }
    
    
}

