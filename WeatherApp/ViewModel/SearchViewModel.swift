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
    let locationInfoSubject = PublishSubject<address>()
    let network = NetworkManager.shared
    
    //MARK: - 검색한 위치의 X, Y 좌표 구하기
    func fetchLocation(){
        let endpoint = Endpoint (
            baseURL: "https://dapi.kakao.com",
            headerParameters: ["Authorization": "KakaoAK 3c7a90563f65e8afc9ebfac9b753c698"],
            path: "/v2/local/search/address",
            queryParameters: ["query" :"전북 삼성동 100"]
        )
//                
//        curl -v -G GET "https://dapi.kakao.com/v2/local/search/address.json" \
//          -H "Authorization: KakaoAK ${REST_API_KEY}" \
//          --data-urlencode "query=전북 삼성동 100"
        
        network.fetch(endpoint: endpoint)
            .subscribe(onSuccess: { [weak self] (result: address) in
                print("+++called SUCCESS Search View Model+++")
                self?.locationInfoSubject.onNext(result)
                print("locationInfo result: \(result)")
            }, onFailure: { [weak self] error in
                print("called ERROR Search ViewModel: \(error)")
            }).disposed(by: disposeBag)
    }
}
    
