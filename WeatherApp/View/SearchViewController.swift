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

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let disposeBag = DisposeBag()
    private var searchView = SearchView(frame: .zero)
    
    override func loadView() {
        searchView = SearchView(frame: UIScreen.main.bounds)
        self.view = searchView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.collectionView.delegate = self
        searchView.collectionView.dataSource = self
        searchView.collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell")
        bindSearchBar()
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
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height / 4 - 10
        let widht = collectionView.frame.width
        return CGSize(width: widht, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
        return cell
    }
    
}
