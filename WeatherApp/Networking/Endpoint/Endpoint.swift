//
//  Endpoint.swift
//  WeatherApp
//
//  Created by Karan . on 9/13/24.
//

import Foundation
import Foundation
import Combine

public enum HttpMethod: String {
    case GET
    case POST
    case PUT
    case HEAD
    case DELETE
}


protocol Endpoint {
    var host: String { get }

    var path: String { get }

    var queryItems: [URLQueryItem] { get }

    var httpMethod: HttpMethod { get set }

    var url: URL? { get }

    var request: URLRequest? { get }
}

extension Endpoint {


    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = self.host
        components.path = self.path
        if !queryItems.isEmpty {
            components.queryItems = self.queryItems
        }

        return components.url
    }

    var request: URLRequest? {
        guard let url = self.url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod  = self.httpMethod.rawValue

        return urlRequest
    }
}



