//
//  UserDefaultManager.swift
//  WeatherApp
//
//  Created by 박승환 on 8/21/24.
//

import Foundation
import RxSwift
import RxCocoa

class UserDefaultManager {
    static let shared = UserDefaultManager()
    private let userDefaults = UserDefaults.standard
    private let regionsRelay: BehaviorRelay<[String]>
    
    private init() {
        let savedregions = userDefaults.stringArray(forKey: "saveRegions") ?? []
        regionsRelay = BehaviorRelay(value: savedregions)
    }
    
    var regions: Observable<[String]> {
        return regionsRelay.asObservable()
    }
    
    func addRegion(region: String) {
        print(region)
        var currentRegions = regionsRelay.value
        if !currentRegions.contains(region) {
            currentRegions.append(region)
            regionsRelay.accept(currentRegions)
            userDefaults.set(currentRegions, forKey: "saveRegions")
        }
    }
    
    func removeRegion(_ region: String) {
        var currentRegions = regionsRelay.value
        if let index = currentRegions.firstIndex(of: region) {
            currentRegions.remove(at: index)
            regionsRelay.accept(currentRegions)
            userDefaults.set(currentRegions, forKey: "saveRegions")
        }
    }
    
    
}
