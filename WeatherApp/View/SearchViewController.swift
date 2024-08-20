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
    
    private let regions = Observable.just(["서울특별시", "경기도", "전라도", "강원도"])
    private let filteredRegions = BehaviorRelay<[String]>(value: [])
    
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
    let searchVM = SearchViewModel()
    
    override func loadView() {
        searchView = SearchView(frame: UIScreen.main.bounds)
        self.view = searchView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.collectionView.delegate = self
        //        searchView.collectionView.dataSource = self
        searchView.collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "WeatherCollectionViewCell")
        searchView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        bindSearchBar()
        bindTableView()
        //득령추가
        print("called SearchVC")
        bindViewModel()
        weatherVM.fetchWeather()
        
        //지현 추가
        searchVM.fetchLocation()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func bindSearchBar() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] _ in
                UIView.animate(withDuration: 0.3) {
                    self?.view.frame.origin.y = -50
                    self?.searchView.hideTitle()
                    self?.searchView.showTableView()
                    self?.searchView.showButton()
                }
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [weak self] _ in
                UIView.animate(withDuration: 0.3) {
                    self?.view.frame.origin.y = 0
                    self?.searchView.showTitle()
                    self?.searchView.hideTableView()
                    self?.searchView.hideButton()
                }
            }).disposed(by: disposeBag)
        
        searchView.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { [unowned self] query in
                if query.isEmpty {
                    return self.regions
                } else {
                    return self.regions
                        .map { regions in
                            regions.filter { $0.contains(query) }
                        }
                }
            }.bind(to: filteredRegions)
            .disposed(by: disposeBag)
        
        searchView.cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.searchView.searchBar.resignFirstResponder()
            }).disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        filteredRegions
            .bind(to: searchView.tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (row, region, cell) in
                cell.textLabel?.text = region
            }.disposed(by: disposeBag)
        
        searchView.tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let addRegionVC = AddRegionViewController()
                addRegionVC.modalPresentationStyle = .pageSheet
                self?.present(addRegionVC, animated: true, completion: nil)
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
