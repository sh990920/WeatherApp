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
    let locationInfoSubject = BehaviorSubject(value: [])
    
//    let query = URLQueryItem(name: "query", value: "서울 용산구 한강대로 405")
    let url = "https://dapi.kakao.com/v2/local/search/address?query=서울 용산구 한강대로 405)"
    
    
    //MARK: - 검색한 위치의 X, Y 좌표 구하기
//    func fetchLocation(){
//        
//        NetworkMnanger.shared.fetchData(urlString: url, querys: nil) { (result: Result<LocationInfo, Error>) in
//            switch result {
//            case .success(let locationInfo):
//                print("called Success SearchViewmodel")
//                DispatchQueue.main.async {
//                    let locationInfo = locationInfo.documents
//                    self.locationInfoSubject.onNext(locationInfo)
//                    print("SearchVM: \(locationInfo)") //addressName, x/y 좌표 출력
//                }
//            case .failure(let error):
//                print("called ERROR SearchViewmodel: \(error)")
//            }
//        }
//    }
}
