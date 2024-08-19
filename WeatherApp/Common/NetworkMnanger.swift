//
//  NetworkMnanger.swift
//  WeatherApp
//
//  Created by 이득령 on 8/12/24.
//

import Foundation
import RxSwift

class NetworkMnanger {
    
    static let shared = NetworkMnanger()
    private init () {}
    
    
    func fetch<T: Decodable>(endpoint: Endpoint) -> Single<T> {
        do {
            // data 를 받고 json 디코딩 과정까지 성공한다면 결과를 success 와 함께 방출.
            let request = try endpoint.creatEndpoint()
            return Single.create { observer in
                
                let session = URLSession(configuration: .default)
                session.dataTask(with: request) { data, response, error in
                    
                    // error 가 있다면 Single 에 fail 방출.
                    if let error = error {
                        observer(.failure(error))
                        return
                    }
                    
                    // data 가 없거나 http 통신 에러 일 때 dataFetchFail 방출.
                    guard let data = data,
                          let response = response as? HTTPURLResponse,
                          (200..<300).contains(response.statusCode) else {
                        observer(.failure(NSError(domain: "데이터 에러", code: -1, userInfo: nil)))
                        return
                    }
                    
                    do {
                        // data 를 받고 json 디코딩 과정까지 성공한다면 결과를 success 와 함께 방출.
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        observer(.success(decodedData))
                    } catch {
                        // 디코딩 실패했다면 decodingFail 방출.
                        observer(.failure(error))
                    }
                }.resume()
                
                return Disposables.create()
            }
        } catch let error {
            return Single.create { observer in
                observer(.failure(error))
                return Disposables.create()
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
    
    
    
}
