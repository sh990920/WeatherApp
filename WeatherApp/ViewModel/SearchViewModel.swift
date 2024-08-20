//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by 박승환 on 8/12/24.
//

import Foundation
import RxSwift

class SearchViewModel {
    
    private let disposeBag = DisposeBag()
    
    //view가 구독할 Subject

    let locationInfoSubject = PublishSubject<LocationInfo>()
    let text = BehaviorSubject<String>(value: "")
    let network = NetworkManager.shared
    let locationListSubject = PublishSubject<[LocationInfo]>()
    
    let addressInfoSubject = PublishSubject<AddressInfo>()
    
    func fetchAllLocations(querys: [String]) {
        let locationFetchs = querys.map { query -> Single<LocationInfo> in
            let endpoint = Endpoint (
                baseURL: "https://dapi.kakao.com",
                headerParameters: ["Authorization": "KakaoAK 3c7a90563f65e8afc9ebfac9b753c698"],
                path: "/v2/local/search/address",
                queryParameters: ["query": query]
            )
            
            return network.fetch(endpoint: endpoint)
        }
        Single.zip(locationFetchs).observe(on: MainScheduler.instance).subscribe(onSuccess: { [weak self] result in
            guard let self = self else { return }
            var locations: [LocationInfo] = []
            locations.append(contentsOf: result)
            self.locationListSubject.onNext(locations)
        }, onFailure: { error in
            self.locationListSubject.onError(error)
        }).disposed(by: disposeBag)
    }
    
    
    //MARK: - 검색한 위치의 X, Y 좌표 구하기
    func fetchLocation(query: String) {
        let endpoint = Endpoint (
            baseURL: "https://dapi.kakao.com",
            headerParameters: ["Authorization": "KakaoAK 3c7a90563f65e8afc9ebfac9b753c698"],
            path: "/v2/local/search/address",
            queryParameters: ["query" :query]
        )
        
        network.fetch(endpoint: endpoint)
            .subscribe(onSuccess: { [weak self] (result: LocationInfo) in
                print("+++called SUCCESS Search View Model+++")
                self?.locationInfoSubject.onNext(result)
                print("locationInfo result: \(result)")
            }, onFailure: { error in
                print("called ERROR Search ViewModel: \(error)")
            }).disposed(by: disposeBag)
    }
    func updateText(_ newText: String) {
            text.onNext(newText)
            fetchLocation(query: newText)
        }
    
    func fetchAddress(x: String, y: String) {
        let endpoint = Endpoint (
            baseURL: "https://dapi.kakao.com",
            headerParameters: ["Authorization": "KakaoAK 3c7a90563f65e8afc9ebfac9b753c698"],
            path: "/v2/local/geo/coord2address",
            queryParameters: [
                "x" :x,
                "y": y
            ]
        )
        network.fetch(endpoint: endpoint)
            .subscribe(onSuccess: { [weak self] (result: AddressInfo) in
                print("+++called SUCCESS Search View Model+++")
                self?.addressInfoSubject.onNext(result)
                print("locationInfo result: \(result)")
            }, onFailure: { error in
                print("called ERROR Search ViewModel: \(error)")
            }).disposed(by: disposeBag)
    }
}

    
