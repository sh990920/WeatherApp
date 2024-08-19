//
//  NetworkMnanger.swift
//  WeatherApp
//
//  Created by 이득령 on 8/12/24.
//

import Foundation

class NetworkMnanger {
    
    static let shared = NetworkMnanger()
    private init () {}
    
    func fetchData<T: Decodable>(
        urlString: String?,
        querys: URLQueryItem?,
        completion: @escaping (Result<T, Error>) -> Void) {
            
            // URL 유효성 검사
            guard let urlString,
                  var components = URLComponents(string: urlString) else { return }
            guard let url = components.url else { return }
            
            //URLRequest 생성
            var request = URLRequest(url: url)
            
//            if querys != nil {
                let safeQuerys = querys
                
//                let headers: [String: String]? = [
//                    "Authorization": "KakaoAK 3c7a90563f65e8afc9ebfac9b753c698"
//                ]

                request.setValue("KakaoAK 3c7a90563f65e8afc9ebfac9b753c698", forHTTPHeaderField: "Authorization")
                
            
                
//            }
            
            URLSession.shared.dataTask(with: request)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    completion(.failure(NSError(domain: "데이터 에러", code: -1, userInfo: nil)))
                    return
                }
//                dump(String(data: data, encoding: .utf8))
                
                do {
                    let decoder = JSONDecoder()
                    let Data = try decoder.decode(T.self, from: data)
                    completion(.success(Data))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    
    
    
}
