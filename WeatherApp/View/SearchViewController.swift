//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by 박승환 on 8/12/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    private let disposeBag = DisposeBag()
    private var searchView = SearchView(frame: .zero)
    //득령추가
    private let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.backgroundColor = .white
            return collectionView
        }()

    
    let weatherVM = WeatherViewModel()
    
    override func loadView() {
        searchView = SearchView(frame: UIScreen.main.bounds)
        self.view = searchView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.collectionView.delegate = self
//        searchView.collectionView.dataSource = self
        searchView.collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "WeatherCollectionViewCell")
        bindSearchBar()
        
        //득령추가
        print("called SearchVC")
        bindViewModel()
        weatherVM.fetchWeather()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func bindSearchBar() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] _ in
                UIView.animate(withDuration: 0.3) {
                    self?.view.frame.origin.y = -70
                    self?.searchView.hideTitle()
                }
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [weak self] _ in
                UIView.animate(withDuration: 0.3) {
                    self?.view.frame.origin.y = 0
                    self?.searchView.showTitle()
                }
            }).disposed(by: disposeBag)
    }
    private func bindViewModel() {
        weatherVM.weatherDataSubject
            .observe(on: MainScheduler.instance)
            .bind(to: searchView.collectionView.rx.items(
                cellIdentifier: SearchCollectionViewCell.reuseIdentifier,
                cellType: SearchCollectionViewCell.self)) { row, weatherItem, cell in
                    cell.configureStackViewUI(with: weatherItem)
            }
            .disposed(by: disposeBag)
    }
    
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height / 4 - 10
        let widht = collectionView.frame.width
        return CGSize(width: widht, height: height)
    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
//        return cell
//    }
    
}
