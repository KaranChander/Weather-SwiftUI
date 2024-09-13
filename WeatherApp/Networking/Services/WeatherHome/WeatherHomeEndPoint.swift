//
//  WeatherHomeEndPoint.swift
//  WeatherApp
//
//  Created by Karan . on 9/13/24.
//

import Foundation
struct WeatherHomeEndPoint: Endpoint {
    var host: String
    
    var path: String
    
    var queryItems: [URLQueryItem]
    
    var httpMethod: HttpMethod
    
    
    init(host: String = APIEnvironment.development.baseUrl, path: String, queryItems: [URLQueryItem] = [], httpMethod: HttpMethod = .GET) {
        self.host = host
        self.path = path
        self.queryItems = queryItems
        self.httpMethod = httpMethod
    }
}
