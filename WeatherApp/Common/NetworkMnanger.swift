//
//  NetworkMnanger.swift
//  WeatherApp
//
//  Created by 이득령 on 8/12/24.
//

import Foundation
import UIKit

class NetworkMnanger {
    
    static let shared = NetworkMnanger()
    private init () {}
    
    func fetchWeatherData(url: URL, completion: @escaping (Result<Welcome, Error>) -> Void) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "데이터 에러", code: -1, userInfo: nil)))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let weatherData = try decoder.decode(Welcome.self, from: data)
                    completion(.success(weatherData))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
}
