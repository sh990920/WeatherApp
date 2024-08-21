//
//  CurrentDateWeather.swift
//  WeatherApp
//
//  Created by 박승환 on 8/20/24.
//

import Foundation

struct WeatherResponse: Codable {
    let name: String
    let weather: [CurrentWeather]
    let main: CurrentMain
    let sys: CurrentSys
    let timezone: Int
}

struct CurrentWeather: Codable {
    let description: String
    let icon: String
}

struct CurrentMain: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Int
}

struct CurrentSys: Codable {
    let sunrise: Int
    let sunset: Int
}
