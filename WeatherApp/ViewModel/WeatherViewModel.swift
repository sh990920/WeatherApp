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
        let key = "9ac664b5f66b54917a75e04977cbbea0"
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=Seoul&appid=\(key)"
        
        //networkmanager을 통해 데이터가져오기
        network.fetchData(urlString: urlString, querys: nil) { [weak self] (result: Result<Welcome, Error>) in
            //network 요청결과 처리
            switch result {
            case .success(let weatherData):
                print("+++called SUCCESS WeatherViewmodel+++")
                DispatchQueue.main.async {
                    let weatherList = weatherData.list
                    let weatherCity = weatherData.city
                    self?.weatherDataSubject.onNext(weatherList)
                    self?.weatherCitySubject.onNext(weatherCity)
                }
            case .failure(let error):
                print("called ERROR Weater Viewmodel: \(error)")
            }
        }
    }
    
}

