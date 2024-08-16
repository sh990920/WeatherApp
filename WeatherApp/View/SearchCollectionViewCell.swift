//
//  SearchCollectionViewCell.swift
//  WeatherApp
//
//  Created by 박승환 on 8/13/24.
//

import Foundation
import UIKit
import SnapKit

class SearchCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "WeatherCollectionViewCell"
    
    private let firstStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 위치"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "11:00"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.text = "30도"
        label.font = .boldSystemFont(ofSize: 50)
        label.textColor = .white
        return label
    }()
    
    private let minTempLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.text = "최저 : 25"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private let maxTempLabel: UILabel = {
        let label = UILabel()
        label.text = "최고 : 35"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .blue
        //        configureStackViewUI(with: List)
        contentView.addSubview(firstStackView)
        contentView.addSubview(tempLabel)
        contentView.addSubview(maxTempLabel)
        contentView.addSubview(minTempLable)
        
        firstStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
        }
        
        tempLabel.snp.makeConstraints {
            $0.centerY.equalTo(firstStackView)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        maxTempLabel.snp.makeConstraints {
            $0.top.equalTo(firstStackView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(10)
        }
        
        minTempLable.snp.makeConstraints {
            $0.top.equalTo(firstStackView.snp.bottom).offset(20)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
    }
    
    func configureStackViewUI(with weather: List) {
        firstStackView.addArrangedSubview(locationLabel)
        firstStackView.addArrangedSubview(timeLabel)
        //득령 추가
        tempLabel.text = "\(Int(weather.main.temp - 273.15))°C"
        maxTempLabel.text = "\(Int(weather.main.tempMax - 273.15))°C"
        minTempLable.text = "\(Int(weather.main.tempMin - 273.15))°C"
 
    }
    
    
}
