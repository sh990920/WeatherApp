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

class SearchViewController: UIViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    private let filteredRegions = BehaviorRelay<[Document]>(value: [])
    private var searchData: LocationInfo? = nil {
        didSet {
            updateFilteredRegions()
        }
    }
    
    var locationText: Observable<String> {
        searchView.searchBar.rx.text.orEmpty.asObservable()
    }
    
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
        searchView.searchBar.delegate = self
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
        dataSetting()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func dataSetting() {
        searchVM.locationInfoSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] locationInfo in
            self?.searchData = locationInfo
        }, onError: { error in
            print("데이터 바인딩 실패")
        }).disposed(by: disposeBag)
    }
    
    private func updateFilteredRegions() {
        guard let searchData = searchData else {
            filteredRegions.accept([]) // searchData가 nil일 경우 filteredRegions를 빈 배열로 설정
            return
        }

        // searchData에서 regions 목록을 가져와서 filteredRegions에 설정
        let regions = searchData.documents.map { $0 }
        filteredRegions.accept(regions)
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
            .subscribe(onNext: { [unowned self] query in
                // 검색어에 상관없이 항상 모든 데이터를 보여줍니다.
                if query.isEmpty {
                    // 검색어가 비어 있으면 전체 데이터를 표시
                    updateFilteredRegions()
                }
            }).disposed(by: disposeBag)
        
        searchView.cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.searchView.searchBar.resignFirstResponder()
            }).disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        filteredRegions
            .bind(to: searchView.tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (row, region, cell) in
                cell.textLabel?.text = region.addressName
            }.disposed(by: disposeBag)
        
        searchView.tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let viewController = AddRegionViewController()
                if let self = self {
                    viewController.dataSetting(data: self.filteredRegions.value[indexPath.item])
                }
                let addRegionVC = UINavigationController(rootViewController: viewController)
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        print("Searching for: \(query)")
        searchVM.fetchLocation(query: query)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height / 4 - 10
        let widht = collectionView.frame.width
        return CGSize(width: widht, height: height)
    }
    
}
