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
    let headerParpmeters: [String: String]
    let path: String
    let queryParameters: [String: Any]
    
    
    init(baseURL: String = "",
         method: HTTPMethodType = .get,
         headerParpmeters: [String : String] = [:],
         path: String = "",
         queryParameters: [String : Any] = [:]
    ) {
        self.baseURL = baseURL
        self.method = method
        self.headerParpmeters = headerParpmeters
        self.path = path
        self.queryParameters = queryParameters
    }
    
    
    func creatURL() -> URL? {
        var urlComponents = URLComponents(string: baseURL.appending(path))
        print("creatURL() urlComponents: \(urlComponents) ")
        
        
        var queryItems = [URLQueryItem]() // name, value 속성 있음
        
        
        queryParameters.forEach {
            print("여기에 들어왔음?????")
            queryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
            print("URLQueryItem(name: $0.name, value: $0.value): \(queryItems)")
        }
        
        print("creatURL() queryItems: \(queryItems)")
        
        urlComponents?.queryItems = queryItems
        
        return urlComponents?.url
        
    }
    
    func creatEndpoint() throws -> URLRequest {   //여기서 throws 사용하는 이유?
        guard let url = creatURL() else {throw NetworkError.invalidUrl}
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        var allHeaders: [String: String] = [:]
        headerParpmeters.forEach {
            allHeaders.updateValue($1, forKey: $0)
        }
        return request
    }
    
}


