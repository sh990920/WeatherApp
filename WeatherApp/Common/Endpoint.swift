//
//  Endpoing.swift
//  WeatherApp
//
//  Created by ahnzihyeon on 8/19/24.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case dataFetchFail
    case decodingFail
}

enum HTTPMethodType: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

final class Endpoint{
    let baseURL: String
    let method: HTTPMethodType
    let headerParameters: [String: String]
    let path: String
    var queryParameters: [String: String]
    
    
    init(baseURL: String = "",
         method: HTTPMethodType = .get,
         headerParameters: [String : String] = [:],
         path: String = "",
         queryParameters: [String : String] = [:]
    ) {
        self.baseURL = baseURL
        self.method = method
        self.headerParameters = headerParameters
        self.path = path
        self.queryParameters = queryParameters
    }
    
    
    func creatURL() -> URL? {
        var urlComponents = URLComponents(string: baseURL.appending(path))
        
        var queryItems = [URLQueryItem]() // name, value 속성 있음
        
        queryParameters.forEach {
            queryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        
        print("creatURL() queryItems: \(queryItems)")
        
        urlComponents?.queryItems = queryItems
        
        return urlComponents?.url
    }
    
    
    func creatEndpoint() throws -> URLRequest {
        guard let url = creatURL() else { throw NetworkError.invalidUrl}
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        var allHeaders: [String: String] = [:]
        headerParameters.forEach {
            allHeaders.updateValue($1, forKey: $0)
        }
        
        request.allHTTPHeaderFields = headerParameters
        
        return request
    }
    

    
}


