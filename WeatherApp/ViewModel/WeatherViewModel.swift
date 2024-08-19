//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by 이득령 on 8/13/24.
//

import UIKit
import RxSwift
import RxCocoa
// MainView에서 사용하면 좋을것 같습니다
class WeatherViewModel {
    
    private let disposeBag = DisposeBag()
    
    // UI와 바인딩될 날씨 데이터를 보유하는 BehaviorSubject
    let weatherDataSubject = BehaviorSubject<[List]>(value: [])
    let weatherCitySubject = BehaviorSubject<City>(value: City(id: 0, name:"", coord: Coord(lat: 0.0, lon: 0.0), country: "", population: 0, timezone: 0, sunrise: 0, sunset: 0))
    
    let network = NetworkMnanger.shared
    
    //MARK: - 날씨 가져오기
    func fetchWeather() {
        
        let endpoint = Endpoint(
            baseURL: "https://api.openweathermap.org",
            path: "/v2/local/search/address",
            queryParameters: [
                "q": "“Seoul”",
                "appid": "9ac664b5f66b54917a75e04977cbbea0"
            ]
        )
        
        
        //networkmanager을 통해 데이터가져오기
        network.fetch(endpoint: endpoint)
            .subscribe(onSuccess: { [weak self] (result: Welcome) in
                print("+++called SUCCESS WeatherViewmodel+++")
                
            }, onFailure: { [weak self] error in
                print("called ERROR Weater Viewmodel: \(error)")
            }).disposed(by: disposeBag)
                        
                        
        
//        network.fetch(endpoint: endpoint) { [weak self] (result: Result<Welcome, Error>) in
//            //network 요청결과 처리
//            switch result {
//            case .success(let weatherData):
//                print("+++called SUCCESS WeatherViewmodel+++")
//                DispatchQueue.main.async {
//                    let weatherList = weatherData.list
//                    let weatherCity = weatherData.city
//                    self?.weatherDataSubject.onNext(weatherList)
//                    self?.weatherCitySubject.onNext(weatherCity)
//                }
//            case .failure(let error):
//                print("called ERROR Weater Viewmodel: \(error)")
//            }
//        }
    }
    
}

