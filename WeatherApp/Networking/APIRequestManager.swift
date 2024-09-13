//
//  APIRequestManager.swift
//  WeatherApp
//
//  Created by Karan . on 9/13/24.
//

import Foundation




open class APIRequestManager: NSObject {
    
    
    func getAPIKey() -> String {
        guard let filePath = Bundle.main.path(forResource: "config", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let apiKey = plist["API_KEY"] as? String else {
            fatalError("Could not find API key")
        }
        return apiKey
    }
    
}


enum APIEnvironment {
    case development
    case production
    
    var baseUrl: String {
        switch self {
        case .development:
            return "api.openweathermap.org"
        case .production:
            return "api.openweathermap.org"
        }
    }
}

