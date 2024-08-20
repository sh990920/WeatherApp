//
//  LocationInfoModel.swift
//  WeatherApp
//
//  Created by ahnzihyeon on 8/16/24.
//

import Foundation

// MARK: - LocationInfo
struct LocationInfo: Codable {
    let documents: [Document]
}

// MARK: - Document
struct Document: Codable {
    let addressName: String
    let x: String
    let y: String
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case x, y
    }
}

