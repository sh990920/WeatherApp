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
    
    var data: Document? = nil {
        didSet {
            if let data = data {
                weatherVM.fetchWeather(y: data.y, x: data.x)
            }
        }
    }
    
    private let addRegionView: MainView = {
        let view = MainView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
        bindButtons()
        bindWeatherData()
    }
    
    func dataSetting(data: Document) {
        self.data = data
    }
    
    func bindWeatherData() {
        weatherVM.weatherDataSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] list in
            self?.weatherList = list
            //일일 데이터로 수정하고 바꿔주세요
            print(self?.weatherList)
        }, onError: { error in
            print("데이터 추가 실패")
        })
    }
    
    private func bindButtons() {
        guard let addButton = navigationItem.rightBarButtonItem,
              let cancelButton = navigationItem.leftBarButtonItem else { return }
        
        addButton.rx.tap
            .subscribe(onNext: { [weak self] in
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: nil)
    }
}
