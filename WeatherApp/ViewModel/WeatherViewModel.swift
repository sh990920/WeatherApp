//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by 이득령 on 8/13/24.
//

import UIKit
import RxSwift
//import RxCocoa
// MainView에서 사용하면 좋을것 같습니다
class WeatherViewModel {
    
    private let disposeBag = DisposeBag()
    
    let searchVM = SearchViewModel()
    
    // UI와 바인딩될 날씨 데이터를 보유하는 BehaviorSubject
    let weatherDataSubject = BehaviorSubject<[List]>(value: [])
    let weatherCitySubject = BehaviorSubject<City>(value: City(id: 0, name:"", coord: Coord(lat: 0.0, lon: 0.0), country: "", population: 0, timezone: 0, sunrise: 0, sunset: 0))
    
    let network = NetworkManager.shared
    
    //MARK: - 날씨 가져오기
    func fetchWeather(y: String, x: String) {
        
        let endpoint = Endpoint(
            baseURL: "https://api.openweathermap.org",
            path: "/data/2.5/forecast",
            queryParameters: [
                "lat": y,
                "lon": x,
                "appid": "9ac664b5f66b54917a75e04977cbbea0"
            ]
        )
        
//        networkmanager을 통해 데이터가져오기
        network.fetch(endpoint: endpoint)
            .subscribe(onSuccess: { [weak self] (result: Welcome) in
                print("+++called SUCCESS WeatherViewmodel+++")
                self!.weatherDataSubject.onNext(result.list)
            }, onFailure: { [weak self] error in
                print("called ERROR Weater Viewmodel: \(error)")
            }).disposed(by: disposeBag)
    }

}
