//
//  ViewController.swift
//  WeatherApp
//
//  Created by 박승환 on 8/12/24.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    private let mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        configureCollectionView()
    }
    
    private func configureUI() {
        //        mainView.backgroundColor = .white
    }
    
    private func configureTableView() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
    
    private func configureCollectionView() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "MainCollectionViewCell")
    }
}

// MARK: - UICollectionViewDataSource, UICollectViewDelegate
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // 임시 더미데이터
        let times = ["현재", "오전 12시", "오후 3시", "오후 6시", "오후 9시"]
        let temperatures = ["32","35","28","30","31"]
        let weatgerIcons = ["","","","",""] // 아이콘 찾아올게...
        
        cell.configure(time: times[indexPath.row], temperature: temperatures[indexPath.row], wetherIconName: weatgerIcons[indexPath.row])
        
        return cell
    }

}


// MARK: - UITableViewDataSource, UITableViewDelegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        // 셀 UI 디테일 설정
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        // 임시 더미데이터
        let days = ["오늘", "화", "수", "목", "금"]
        let temperatures = ["최고: 34°C 최저: 24°C", "최고: 34°C 최저: 24°C", "최고: 34°C 최저: 24°C", "최고: 34°C 최저: 24°C", "최고: 34°C 최저: 24°C"]
        let weatherIcons = ["sunny", "sunny", "sunny", "sunny", "sunny"] // 아이콘 이름을 실제 이미지 이름으로 대체
        
        // 여기에 데이터 값 넣으면 됨 (메인 테이블 뷰 셀도 같이 수정)
        cell.configure(with: days[indexPath.row], weatherIconName: weatherIcons[indexPath.row], temperature: temperatures[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 // 각 행의 높이 설정
    }
}
