//
//  SearchView.swift
//  WeatherApp
//
//  Created by 박승환 on 8/12/24.
//

import UIKit
import SnapKit

class SearchView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "날씨"
        label.font = .boldSystemFont(ofSize: 40)
        return label
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "도시 또는 위치 검색"
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.isHidden = true
        return button
    }()
    
    let searchStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 5
        return stackview
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        return tableView
    }()
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        configureUI()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideButton() {
        cancelButton.isHidden = true
    }
    func showButton() {
        cancelButton.isHidden = false
    }
    
    func hideTableView() {
        tableView.isHidden = true
    }
    func showTableView() {
        tableView.isHidden = false
    }
    func hideTitle() {
        titleLabel.isHidden = true
    }
    func showTitle() {
        titleLabel.isHidden = false
    }
    
    private func configureUI() {
        [
            titleLabel,
            collectionView,
            tableView,
            searchStackView
        ].forEach { addSubview($0) }
        [
            searchBar,
            cancelButton
        ].forEach { searchStackView.addArrangedSubview($0)}
        
    }
    private func setConstraints() {
        searchStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(searchBar.snp.top)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}


