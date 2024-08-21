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
    let currentWeatherSubject = PublishSubject<WeatherResponse>()
    let weatherCitySubject = BehaviorSubject<City>(value: City(id: 0, name:"", coord: Coord(lat: 0.0, lon: 0.0), country: "", population: 0, timezone: 0, sunrise: 0, sunset: 0))
    
    let todayDataSubject = PublishSubject<[showTimeWeather]>()
    let otherDataSubject = PublishSubject<[showWeekWeather]>()
    
    let weatherListSubject = PublishSubject<[WeatherResponse]>()
    
    let network = NetworkManager.shared
    
    //MARK: - 날씨 가져오기
    func fetchWeather(y: String, x: String) {
        
        let endpoint = Endpoint(
            baseURL: "https://api.openweathermap.org",
            path: "/data/2.5/forecast",
            queryParameters: [
                "lat": y,
                "lon": x,
                "units": "metric",
                "lang": "kr",
                "appid": "9ac664b5f66b54917a75e04977cbbea0"
            ]
        )
        
//        networkmanager을 통해 데이터가져오기
        network.fetch(endpoint: endpoint)
            .subscribe(onSuccess: { [weak self] (result: Welcome) in
                print("+++called SUCCESS WeatherViewmodel+++")
                self!.weatherDataSubject.onNext(result.list)
                self?.dateDistinction()
            }, onFailure: { error in
                print("called ERROR Weater Viewmodel: \(error)")
            }).disposed(by: disposeBag)
    }
    
    func dateDistinction() {
        weatherDataSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] (list: [List]) in
            let calender = Calendar.current
            let now = Date()
            
            guard let endOfRange = calender.date(byAdding: .hour, value: 24, to: now) else { return }
            var todayList: [showTimeWeather] = []
            var otherList: [showWeekWeather] = []
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let inputDateFormatter = DateFormatter()
            inputDateFormatter.dateFormat = "dd일 HH시"
            
            list.forEach { data in
                if let dataDate = dateFormatter.date(from: data.dtTxt) {
                    if dataDate >= now && dataDate <= endOfRange {
                        todayList.append(showTimeWeather(time: inputDateFormatter.string(from: dataDate), temp: Int(data.main.temp)))
                    }
                }
            }
            
            otherList = self?.weakDataSetting(weatherData: list) ?? []
            self?.todayDataSubject.onNext(todayList)
            self?.otherDataSubject.onNext(otherList)

        }, onError: { error in
            self.todayDataSubject.onError(error)
            self.otherDataSubject.onError(error)
        }).disposed(by: disposeBag)
    }
    
    func weakDataSetting(weatherData: [List]) -> [showWeekWeather] {
        var returnData: [showWeekWeather] = []
        
        var groupData: [String: [List]] = [:]
        
        weatherData.forEach { data in
            let dateString = String(data.dtTxt.split(separator: " ")[0])
            
            if groupData[dateString] == nil {
                groupData[dateString] = [data]
            } else {
                groupData[dateString]?.append(data)
            }
            
        }
        
        let keys = groupData.keys
        for i in keys {
            var min = 100
            var max = -100
            guard let value = groupData[i] else { return returnData }
            for data in value {
                if min >= Int(data.main.tempMin) {
                    min = Int(data.main.tempMin)
                }
                if max <= Int(data.main.tempMax) {
                    max = Int(data.main.tempMax)
                }
            }
            let weather = showWeekWeather(date: i, maxTemp: max, minTemp: min)
            returnData.append(weather)
        }
        
        return returnData
    }
    
    func fetchCurrentWeather(y: String, x: String) {
        let endPoint = Endpoint(
            baseURL: "https://api.openweathermap.org",
            path: "/data/2.5/weather",
            queryParameters: [
                "lat": y,
                "lon": x,
                "appid": "9ac664b5f66b54917a75e04977cbbea0",
                "units": "metric",
                "lang": "kr"
            ]
        )
        
        network.fetch(endpoint: endPoint)
            .subscribe(onSuccess: { [weak self] (currentWeatherResponse: WeatherResponse) in
                print("+++called SUCCESS WeatherViewmodel2+++")
                self?.currentWeatherSubject.onNext(currentWeatherResponse)
            }, onFailure: { error in
                self.currentWeatherSubject.onError(error)
                print("called ERROR Weater Viewmodel2: \(error)")
            }).disposed(by: disposeBag)
    }
    
    func fetchWeatherList(locations: [LocationInfo]) {
        
        let weatherFetchs = locations.map { location -> Single<WeatherResponse> in
            let endPoint = Endpoint(
                baseURL: "https://api.openweathermap.org",
                path: "/data/2.5/weather",
                queryParameters: [
                    "lat": location.documents[0].y,
                    "lon": location.documents[0].x,
                    "appid": "9ac664b5f66b54917a75e04977cbbea0",
                    "units": "metric",
                    "lang": "kr"
                ]
            )
            
            return network.fetch(endpoint: endPoint)
        }
        Single.zip(weatherFetchs).observe(on: MainScheduler.instance).subscribe(onSuccess: { [weak self] result in
            guard let self = self else { return }
            var weatherList: [WeatherResponse] = []
            weatherList.append(contentsOf: result)
            self.weatherListSubject.onNext(weatherList)
        }, onFailure: { error in
            self.weatherListSubject.onError(error)
        }).disposed(by: disposeBag)
    }

}
