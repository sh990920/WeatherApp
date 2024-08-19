//
//  MainViewCollectionViewCell.swift
//  WeatherApp
//
//  Created by 머성이 on 8/19/24.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    // 시간 레이블
        private let timeLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = .white
            label.textAlignment = .center
            return label
        }()
        
        // 날씨 아이콘 이미지 뷰
        private let weatherIconImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        // 온도 레이블
        private let temperatureLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            label.textColor = .white
            label.textAlignment = .center
            return label
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        [timeLabel, weatherIconImageView, temperatureLabel].forEach {
            contentView.addSubview($0)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        weatherIconImageView.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(weatherIconImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
    
    // 여기에 값 넣어주면 됨! (득령, 지현)
    func configure(time: String, temperature: String, wetherIconName:String) {
        timeLabel.text = time
        temperatureLabel.text = temperature
        weatherIconImageView.image = UIImage(named: "weatherIconName")
    }
}
