//
//  WeatherHomeViewModel.swift
//  WeatherApp
//
//  Created by Karan . on 9/13/24.
//

import Foundation
import Combine
import CoreLocation

class WeatherHomeViewModel: ObservableObject {
    
    let service: WeatherHomeServiceProtocol
    
    @Published var weatherDetail: Weather?
    @Published var cities: [GeoLocation] = []
    @Published var searchText: String = String()
    
    var userManager: UserManager
    var locationManager: LocationManagerProtocol
    var subscription: Set<AnyCancellable> = []


    init(service: WeatherHomeServiceProtocol = WeatherHomeService(),
         userManager: UserManager = UserManager(),
         locationManager: LocationManagerProtocol = LocationManager(userManager: UserManager()))  {
        self.service = service
       self.userManager = userManager
       self.locationManager = locationManager
        searchSubscriber()
        Task {
            await fetchLocationPermission()
        }
    }
    
    func searchSubscriber() {
        $searchText
        .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
        .removeDuplicates()
        .map({ (string) -> String? in
            if string.count < 1 {
                self.cities = []
                return nil
            }
            
            return string
        })
        .compactMap{ $0 }
        .sink { (_) in
            
        } receiveValue: { [weak self] (city) in
            self?.fetchCities(search: city)
        }.store(in: &subscription)
        
        locationManager.userLocationPublisher
                    .sink { [weak self] location in
                        guard let location = location else { return }
                        Task {[weak self] in
                            await self?.fetchGeoLocation(location: location)
                        }
                    }
                    .store(in: &subscription)

    }
    
    func fetchLocationPermission() async {
        if let location = userManager.getUserLocation() {
            await self.fetchGeoLocation(location: location)
        } else {
            locationManager.requestLocationPermission()
        }
    }
    
    func fetchCities(search: String) {
        service.fetchCities(cityName: search)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("success")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: {[weak self] locations in
                self?.cities = locations
            }.store(in: &subscription)
    }
    
    func fetchGeoLocation(location: CLLocation) async {
        do {
            let locations = try await service.fetchGeoCodedLocation(lat: location.coordinate.latitude, long: location.coordinate.longitude)
            if let location = locations.first {
                await self.fetchWeatherDetails(for: location)
            }
        } catch {
            print("\(error)")
        }
    }
    
    @MainActor
    func fetchWeatherDetails(for location: GeoLocation) async {
        do {
            let weatherDetail = try await service.fetchWeatherDetail(lat: location.lat, long: location.lon)
                self.weatherDetail = weatherDetail
                self.cities = []
                self.searchText = ""
        } catch {
            print("\(error)")
        }
    }
    
    
    func getWeatherIcon(icon: WeatherIcon) -> String {
            switch icon {
            case .clearSkyDay:
                return "sun.max.fill"
            case .clearSkyNight:
                return "moon.fill"
            case .fewCloudsDay:
                return "cloud.sun.fill"
            case .fewCloudsNight:
                return "cloud.moon.fill"
            case .scatteredCloudsDay:
                return "cloud.fill"
            case .scatteredCloudsNight:
                return "cloud.fill"
            case .brokenCloudsDay:
                return "cloud.fill"
            case .brokenCloudsNight:
                return "cloud.fill"
            case .showerCloudsDay:
                return "cloud.sun.rain.fill"
            case .showerCloudsNight:
                return "cloud.moon.rain.fill"
            case .rainDay:
                return "cloud.heavyrain.fill"
            case .rainNight:
                return "cloud.heavyrain.fill"
            case .thunderStormDay:
                return "cloud.bolt.fill"
            case .thunderStormNight:
                return "cloud.bolt.fill"
            case .snowDay:
                return "snowflake"
            case .snowNight:
                return "snowflake"
            case .mistDay:
                return "cloud.fog.fill"
            case .mistNight:
                return "cloud.fog.fill"
            }
        }
}


