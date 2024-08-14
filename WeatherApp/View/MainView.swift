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
    // 고정값
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
    
    // MARK: - 테이블 뷰
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupTopViewLayout()
        setupMidViewLayout()
        setupTableViewLayout()
    }
    
    private func configureUI() {
        configureTopViewLayout()
        configureMidViewLayout()
        configureTableViewHeader()
    }
    
    // MARK: - 상단, 중간 뷰 레이아웃
    private func setupTopViewLayout() {
        [topView, midView].forEach {
            self.addSubview($0)
        }
        
        // 상단 섹션 뷰
        topView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(self).multipliedBy(0.3)
        }
        
        // 중단 섹션 뷰
        midView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(152)
        }
    }
    
    private func setupMidViewLayout() {
        [humidityContainer, sunriseSunsetContainer].forEach {
            midView.addSubview($0)
        }
        
        // 습도 레이블 스택뷰
        humidityContainer.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(136)
            $0.width.equalTo(168)
        }
        
        // 밀몰, 일출 레이블 스택뷰
        sunriseSunsetContainer.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(136)
            $0.width.equalTo(168)
        }
        
        // 스택뷰 디테일
        humidityContainer.backgroundColor = .systemBlue
        sunriseSunsetContainer.backgroundColor = .systemBlue
        humidityContainer.layer.cornerRadius = 10
        sunriseSunsetContainer.layer.cornerRadius = 10
    }
    
    // MARK: - 테이블 뷰 레이아웃
    private func setupTableViewLayout() {
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(midView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - 상단 뷰 디테일
    private func configureTopViewLayout() {
        [locationLabel, locationDetailLabel, temperatureLabel, descriptionLabel].forEach {
            topView.addSubview($0)
        }
        
        locationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(88)
            $0.centerX.equalToSuperview()
            $0.height.greaterThanOrEqualTo(32)
        }
        
        locationDetailLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.greaterThanOrEqualTo(16)
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(locationDetailLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.greaterThanOrEqualTo(48)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.greaterThanOrEqualTo(16)
        }
    }
    
    // MARK: - 중단 뷰 디테일
    private func configureMidViewLayout() {
        [humidityLabel, humidityDetailLabel].forEach {
            humidityContainer.addSubview($0)
        }
        
        humidityLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(30)
            $0.height.equalTo(16)
        }
        
        humidityDetailLabel.snp.makeConstraints {
            $0.top.equalTo(humidityLabel.snp.bottom).offset(8)
            $0.leading.equalTo(humidityLabel.snp.leading)
            $0.bottom.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
        }
        
        [sunriseLabel, sunriseDetailLabel, sunsetLabel, sunsetDetailLabel].forEach {
            sunriseSunsetContainer.addSubview($0)
        }
        
        sunriseLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(16)
        }
        
        sunriseDetailLabel.snp.makeConstraints {
            $0.top.equalTo(sunriseLabel.snp.bottom).offset(8)
            $0.leading.equalTo(sunriseLabel.snp.leading)
            $0.height.equalTo(16)
        }
        
        sunsetLabel.snp.makeConstraints {
            $0.top.equalTo(sunriseDetailLabel.snp.bottom).offset(16)
            $0.leading.equalTo(sunriseLabel.snp.leading)
            $0.height.equalTo(16)
        }
        
        sunsetDetailLabel.snp.makeConstraints {
            $0.top.equalTo(sunsetLabel.snp.bottom).offset(8)
            $0.leading.equalTo(sunriseLabel.snp.leading)
            $0.bottom.equalToSuperview().offset(-16)
            $0.height.equalTo(16)
        }
    }
    
    // 헤더 뷰 관련
    private func configureTableViewHeader() {
        tableView.tableHeaderView = createTableViewHeader()
    }
    
    // MARK: - 커스텀 헤더 뷰
    private func createTableViewHeader() -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemBlue
        headerView.layer.cornerRadius = 10
        headerView.layer.masksToBounds = true
        
        let headerLabel = UILabel()
        headerLabel.text = "5일간의 일기예보"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 12)
        headerLabel.textColor = .systemGray5
        headerLabel.textAlignment = .left
        
        headerView.addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
        
        return headerView
    }
}
