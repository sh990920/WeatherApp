//
//  MainViewModel.swift
//  WeatherApp
//
//  Created by 이득령 on 8/12/24.
//

import RxSwift
import RxCocoa

class MainViewModel {
    
    let tableViewData: Observable<[WeatherData]>
    let collectionViewData: Observable<[HourlyWeatherData]>

    init() {
        // 더뮈데이럴~
        tableViewData = Observable.just([
            WeatherData(day: "오늘", temperature: "최고: 34°C 최저: 24°C", weatherIconName: "sunny"),
            WeatherData(day: "화", temperature: "최고: 34°C 최저: 24°C", weatherIconName: "sunny"),
            WeatherData(day: "수", temperature: "최고: 34°C 최저: 24°C", weatherIconName: "sunny"),
            WeatherData(day: "목", temperature: "최고: 34°C 최저: 24°C", weatherIconName: "sunny"),
            WeatherData(day: "금", temperature: "최고: 34°C 최저: 24°C", weatherIconName: "sunny")
        ])
        
        collectionViewData = Observable.just([
            HourlyWeatherData(time: "현재", temperature: "32°C", weatherIconName: "sunny"),
            HourlyWeatherData(time: "오전 12시", temperature: "35°C", weatherIconName: "sunny"),
            HourlyWeatherData(time: "오후 3시", temperature: "28°C", weatherIconName: "sunny"),
            HourlyWeatherData(time: "오후 6시", temperature: "30°C", weatherIconName: "sunny"),
            HourlyWeatherData(time: "오후 9시", temperature: "31°C", weatherIconName: "sunny")
        ])
    }
}

// 임 시 값 이 지 롱 ㅋ ㅋ ~
struct WeatherData {
    let day: String
    let temperature: String
    let weatherIconName: String
}

struct HourlyWeatherData {
    let time: String
    let temperature: String
    let weatherIconName: String
}
