//
//  ViewController.swift
//  WeatherApp
//
//  Created by 박승환 on 8/12/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    private let mainView = MainView()
    private let viewModel = MainViewModel()
    private let weatherVM = WeatherViewModel()
    private let searchVM = SearchViewModel()
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    private let tableViewData = BehaviorRelay<[showWeekWeather]>(value: [])
    private let collectionViewData = BehaviorRelay<[showTimeWeather]>(value: [])
    
    private var searchData: AddressInfo? = nil {
        didSet {
            if let data = searchData,
               let firstDocument = data.documents.first {
                let address = "\(firstDocument.roadAddress.region1depthName) \(firstDocument.roadAddress.region2depthName)"
                mainView.mainUpdateAddressName(addressName: address)
            } else {
                // documents 배열이 비어있을 경우의 처리
                mainView.mainUpdateAddressName(addressName: "주소 정보 없음")
            }
        }
    }
    
    private var todayWeather: [showTimeWeather] = [] {
        didSet {
            collectionViewData.accept(todayWeather)
        }
    }
    private var otherWeather: [showWeekWeather] = [] {
        didSet {
            tableViewData.accept(otherWeather)
            
            // 날짜를 기준으로 내림차순으로 정렬함
            let sortedWeather = otherWeather.sorted { $0.date < $1.date }
            tableViewData.accept(sortedWeather)
        }
    }
    
    private var currentWeather: WeatherResponse? = nil {
        didSet {
            if let currentWeather = currentWeather {
                mainView.updateValue(currentWeather: currentWeather)
            }
        }
    }
    
    func bindWeatherData() {
        
        weatherVM.currentWeatherSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] currentWeather in
            self?.currentWeather = currentWeather
        }, onError: { error in
            print("데이터추가 실패")
        }).disposed(by: disposeBag)
        
        weatherVM.todayDataSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] list in
            self?.todayWeather = list
        }, onError: { error in
            print("데이터추가 실패")
        }).disposed(by: disposeBag)
        
        weatherVM.otherDataSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] list in
            self?.otherWeather = list
        }, onError: { error in
            print("데이터 추가 실패")
        }).disposed(by: disposeBag)
        
        searchVM.addressInfoSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] data in
            self?.searchData = data
        }, onError: { error in
            print("데이터 추가 실패")
        }).disposed(by: disposeBag)
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        mainView.collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "MainCollectionViewCell")
        //bindCollectionView()
        //bindTableView()
        bindWeatherData()
        bindTableViewAndCollectionView()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // CLLocationManagerDelegate 메서드: 위치 업데이트 시 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        weatherVM.fetchWeather(y: String(latitude), x: String(longitude))
        weatherVM.fetchCurrentWeather(y: String(latitude), x: String(longitude))
        searchVM.fetchAddress(x: String(longitude), y: String(latitude))
        // 위치 업데이트 후 위치 추적 중지 (필요한 경우)
        //locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    private func bindTableViewAndCollectionView() {
        tableViewData
            .bind(to: mainView.tableView.rx.items(cellIdentifier: MainTableViewCell.identifier, cellType: MainTableViewCell.self)) { row, model, cell in
                cell.configure(with: model.date, weatherIconName: "sunny", temperature: "최고: \(model.maxTemp)°C 최저: \(model.minTemp)°C")
            }.disposed(by: disposeBag)
        
        // 선택된 항목을 deselect 함으로써 선택되지 않게 함
        mainView.tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.mainView.tableView.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)
        
        collectionViewData
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: "MainCollectionViewCell", cellType: MainCollectionViewCell.self)) { row, model, cell in
                cell.configure(time: model.time, temperature: "\(model.temp)°C", wetherIconName: "sunny")
            }.disposed(by: disposeBag)
        
        // 선택된 항목을 deselect 함으로써 선택되지 않게 함
        mainView.collectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.mainView.collectionView.deselectItem(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)
    }
}
