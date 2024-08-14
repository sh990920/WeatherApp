//
//  MainCollectionViewCell.swift
//  WeatherApp
//
//  Created by 머성이 on 8/14/24.
//

import UIKit
import SnapKit

class MainTableViewCell: UITableViewCell {

    static let identifier = "MainTableViewCell"
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    // 이미지 관련 (데이터 받아와야함)
    private let weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [dayLabel, weatherIcon, temperatureLabel].forEach {
            contentView.addSubview($0)
        }
        
        dayLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
        }
        
        weatherIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(dayLabel.snp.right).offset(16)
            $0.width.height.equalTo(24)
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(weatherIcon.snp.right).offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 정보 받아오는거 이쪽에서 수정 !!! 자료형도 변환해주셈
    func configure(with day: String, weatherIconName: String, temperature: String) {
        dayLabel.text = day
        weatherIcon.image = UIImage(named: weatherIconName)
        temperatureLabel.text = temperature
    }
}
