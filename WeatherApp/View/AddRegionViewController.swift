//
//  AddRegionViewController.swift
//  WeatherApp
//
//  Created by pc on 8/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AddRegionViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let weatherVM = WeatherViewModel()
    private var weatherList = [List]()
    private let tableViewData = BehaviorRelay<[showWeekWeather]>(value: [])
    private let collectionViewData = BehaviorRelay<[showTimeWeather]>(value: [])
    private var isSaved = false
    
    private var todayWeather: [showTimeWeather] = [] {
        didSet {
            collectionViewData.accept(todayWeather)
        }
    }
    private var otherWeather: [showWeekWeather] = [] {
        didSet {
            tableViewData.accept(otherWeather)
            // 날짜 내림차순
            let sortedWeather = otherWeather.sorted { $0.date < $1.date }
            tableViewData.accept(sortedWeather)
        }
    }
    
    private var currentWeather: WeatherResponse? = nil {
        didSet {
            if let currentWeather = currentWeather {
                addRegionView.updateValue(currentWeather: currentWeather)
            }
        }
    }
    
    var data: Document? = nil {
        didSet {
            if let data = data {
                addRegionView.updateAddressName(addressName: data.addressName)
                weatherVM.fetchWeather(y: data.y, x: data.x)
                weatherVM.fetchCurrentWeather(y: data.y, x: data.x)
            }
        }
    }
    
    private let addRegionView: MainView = {
        let view = MainView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRegionView.collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "MainCollectionViewCell")
        configureUI()
        configureNavigationBar()
        bindButtons()
        bindWeatherData()
        bindTableViewAndCollectionView()
    }
    
    func dataSetting(data: Document, isSaved: Bool) {
        self.data = data
        self.isSaved = isSaved
    }
    
    func bindWeatherData() {
        weatherVM.weatherDataSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] list in
            self?.weatherList = list
            //일일 데이터로 수정하고 바꿔주세요
        }, onError: { error in
            print("데이터 추가 실패")
        }).disposed(by: disposeBag)
        
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
    }
    
    private func bindButtons() {
        guard let addButton = navigationItem.rightBarButtonItem,
              let cancelButton = navigationItem.leftBarButtonItem else { return }
        
        addButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let isSaved = self?.isSaved, isSaved {
                    self?.remoteData()
                } else {
                    self?.addData()
                }
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        view.addSubview(addRegionView)
        addRegionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureNavigationBar() {
        if isSaved {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "삭제", style: .done, target: nil, action: nil)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .done, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: nil)
    }
     
    @objc
    private func addData() {
        guard let data = data else { return }
        UserDefaultManager.shared.addRegion(region: data.addressName)
    }
    
    @objc
    private func remoteData() {
        guard let data = data else { return }
        UserDefaultManager.shared.removeRegion(data.addressName)
    }
    
    private func bindTableViewAndCollectionView() {
        tableViewData
            .bind(to: addRegionView.tableView.rx.items(cellIdentifier: MainTableViewCell.identifier, cellType: MainTableViewCell.self)) { row, model, cell in
                cell.configure(with: model.date, weatherIconName: "sunny", temperature: "최고: \(model.maxTemp)°C 최저: \(model.minTemp)°C")
            }.disposed(by: disposeBag)
        
        // 선택된 항목을 deselect 함으로써 선택되지 않게 함
        addRegionView.tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.addRegionView.tableView.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)
        
        collectionViewData
            .bind(to: addRegionView.collectionView.rx.items(cellIdentifier: "MainCollectionViewCell", cellType: MainCollectionViewCell.self)) { row, model, cell in
                cell.configure(time: model.time, temperature: "\(model.temp)°C", wetherIconName: "sunny")
            }.disposed(by: disposeBag)
        
        // 선택된 항목을 deselect 함으로써 선택되지 않게 함
        addRegionView.collectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.addRegionView.collectionView.deselectItem(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)
    }
    
}
