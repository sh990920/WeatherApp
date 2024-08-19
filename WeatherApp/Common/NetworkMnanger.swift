//
//  NetworkMnanger.swift
//  WeatherApp
//
//  Created by 이득령 on 8/12/24.
//

import Foundation
import RxSwift

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetch<T: Decodable>(endpoint: Endpoint) -> Single<T> {
        do {
            let request = try endpoint.createEndpoint()
            return Single.create { observer in
                
                let session = URLSession.shared
                let task = session.dataTask(with: request) { data, response, error in
                    
                    if let error = error {
                        observer(.failure(error))
                        return
                    }
                    
                    guard let data = data,
                          let response = response as? HTTPURLResponse,
                          (200..<300).contains(response.statusCode) else {
                        observer(.failure(NetworkError.dataFetchFail))
                        return
                    }
                    
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        observer(.success(decodedData))
                    } catch {
                        observer(.failure(NetworkError.decodingFail))
                    }
                }
                
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            }
        } catch let error {
            return Single.create { observer in
                observer(.failure(error))
                return Disposables.create()
            }
        }
    }
}
    
    
    
//    func fetchData<T: Decodable>(
//        urlString: String?,
//        querys: URLQueryItem?,
//        completion: @escaping (Result<T, Error>) -> Void) {
//            
//            // URL 유효성 검사
//            guard let urlString,
//                  var components = URLComponents(string: urlString) else { return }
//            guard let url = components.url else { return }
//            
//            //URLRequest 생성
//            var request = URLRequest(url: url)
//            
////            if querys != nil {
//                let safeQuerys = querys
//                
////                let headers: [String: String]? = [
////                    "Authorization": "KakaoAK 3c7a90563f65e8afc9ebfac9b753c698"
////                ]
//
//                request.setValue("KakaoAK 3c7a90563f65e8afc9ebfac9b753c698", forHTTPHeaderField: "Authorization")
//                
//            
//                
////            }
//            
//            URLSession.shared.dataTask(with: request)
//            
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//                guard let data = data else {
//                    completion(.failure(NSError(domain: "데이터 에러", code: -1, userInfo: nil)))
//                    return
//                }
////                dump(String(data: data, encoding: .utf8))
//                
//                do {
//                    let decoder = JSONDecoder()
//                    let Data = try decoder.decode(T.self, from: data)
//                    completion(.success(Data))
//                } catch {
//                    completion(.failure(error))
//                }
//            }
//            task.resume()
//        }
    
    
    

