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

struct AddressInfo: Codable {
    let documents: [AddressDocument]
}

struct AddressDocument: Codable {
    let roadAddress: RoadAddress
    
    enum CodingKeys: String, CodingKey {
        case roadAddress = "road_address"
    }
}

struct RoadAddress: Codable {
    let region1depthName: String
    let region2depthName: String
    
    enum CodingKeys: String, CodingKey {
        case region1depthName = "region_1depth_name"
        case region2depthName = "region_2depth_name"
    }
    
    
}
