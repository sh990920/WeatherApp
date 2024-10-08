//
//  Model.swift
//  WeatherApp
//
//  Created by 이득령 on 8/12/24.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double
}

// MARK: - List
struct List: Codable {
    let dt: Int
    let main: MainClass
    let weather: [Weather]
//    let clouds: Clouds
//    let wind: Wind
//    let visibility: Int
//    let pop: Double
//    let sys: Sys
    let dtTxt: String
//    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather
        case dtTxt = "dt_txt"
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - MainClass
struct MainClass: Codable {
//    let temp, feelsLike, tempMin, tempMax: Double
//    let pressure, seaLevel, grndLevel, humidity: Int
//    let tempKf: Double
    let temp, tempMin, tempMax: Double
    let humidity: Int
//    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
//        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
//        case pressure
//        case seaLevel = "sea_level"
//        case grndLevel = "grnd_level"
        case humidity
//       case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: Pod
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct Weather: Codable {
//    let id: Int
//    let main: MainEnum
    let description: String
    let icon: String
}

//enum Description: String, Codable {
//    case brokenClouds = "broken clouds"
//    case clearSky = "clear sky"
//    case fewClouds = "few clouds"
//    case lightRain = "light rain"
//    case overcastClouds = "overcast clouds"
//    case scatteredClouds = "scattered clouds"
//    case unknown // 기본값
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        let rawValue = try container.decode(String.self)
//        self = Description(rawValue: rawValue) ?? .unknown
//    }
//}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}
