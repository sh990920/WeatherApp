//
//  View.swift
//  WeatherApp
//
//  Created by 이득령 on 8/12/24.
//

import UIKit
import SnapKit
import RxSwift

class MainView: UIView {

    // MARK: - 레이블 폰트 설정 - DS
    private let systemFontLabel: (String, CGFloat, UIColor) -> UILabel = { text, fontSize, textColor in
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textAlignment = .center
        return label
    }
    
    private let boldSystemFontLabel: (String, CGFloat, UIColor) -> UILabel = { text, fontSize, textColor in
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        label.textAlignment = .center
        return label
    }
    
    // MARK: - 레이블 디테일 - DS
    // 고정
    private lazy var locationLabel = boldSystemFontLabel("나의 위치", 32, .black)
    private lazy var humidityLabel = boldSystemFontLabel("습도", 16, .white)
    private lazy var sunriseLabel = boldSystemFontLabel("일출", 16, .white)
    private lazy var sunsetLabel = boldSystemFontLabel("일몰", 16, .white)

    // 변동사항 있음
    private lazy var locationDetailLabel = systemFontLabel("서울시", 16, .black)
    private lazy var temperatureLabel = boldSystemFontLabel("30°C", 48, .black)
    private lazy var descriptionLabel = systemFontLabel("바다 속 보다 더 촉촉함", 16, .black)
    private lazy var humidityDetailLabel = systemFontLabel("70%", 48, .white)
    private lazy var sunriseDetailLabel = boldSystemFontLabel("05:38", 16, .white)
    private lazy var sunsetDetailLabel = boldSystemFontLabel("19:56", 16, .white)

    // MARK: - 섹션별 뷰
    private lazy var topView = UIView()
    private lazy var midView = UIView()
    private lazy var humidityContainer = UIView()
    private lazy var sunriseSunsetContainer = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        // MARK: - 상단 뷰 레이아웃
        [locationLabel, locationDetailLabel, temperatureLabel, descriptionLabel].forEach {
            topView.addSubview($0)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(88)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(32)
        }
        
        locationDetailLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(16)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(locationDetailLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(48)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(16)
        }
        
       // MARK: - 중간 뷰 레이아웃

        // 습도 관련
        [humidityLabel, humidityDetailLabel].forEach {
            humidityContainer.addSubview($0)
        }

        humidityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(16)
        }

        humidityDetailLabel.snp.makeConstraints { make in
            make.top.equalTo(humidityLabel.snp.bottom).offset(8)
            make.leading.equalTo(humidityLabel.snp.leading)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }

        // 일출, 일몰 관련
        [sunriseLabel, sunriseDetailLabel, sunsetLabel, sunsetDetailLabel].forEach {
            sunriseSunsetContainer.addSubview($0)
        }

        sunriseLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(16)
        }

        sunriseDetailLabel.snp.makeConstraints { make in
            make.top.equalTo(sunriseLabel.snp.bottom).offset(8)
            make.leading.equalTo(sunriseLabel.snp.leading)
            make.height.equalTo(16)
        }

        sunsetLabel.snp.makeConstraints { make in
            make.top.equalTo(sunriseDetailLabel.snp.bottom).offset(24)
            make.leading.equalTo(sunriseLabel.snp.leading)
            make.height.equalTo(16)
        }

        sunsetDetailLabel.snp.makeConstraints { make in
            make.top.equalTo(sunsetLabel.snp.bottom).offset(8)
            make.leading.equalTo(sunriseLabel.snp.leading)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(16)
        }

        // MARK: - 습도, 일출, 일몰 관련 뷰
        [humidityContainer, sunriseSunsetContainer].forEach {
            midView.addSubview($0) // 중간 뷰에 추가
        }

        humidityContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(152)
            make.width.equalTo(152)
        }

        sunriseSunsetContainer.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(152)
            make.width.equalTo(152)
        }

        // 컨테이너 배경색 및 둥근 모서리 설정
        humidityContainer.backgroundColor = .systemBlue
        sunriseSunsetContainer.backgroundColor = .systemBlue
        humidityContainer.layer.cornerRadius = 10
        sunriseSunsetContainer.layer.cornerRadius = 10
    }

    // MARK: - 상단, 중간 뷰 레이아웃
    private func setupUI() {
        self.addSubview(topView)
        self.addSubview(midView)

        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(self).multipliedBy(0.3)
        }

        midView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(152)
        }
    }
}


