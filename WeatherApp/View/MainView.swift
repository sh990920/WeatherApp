//
//  View.swift
//  WeatherApp
//
//  Created by 이득령 on 8/12/24.
//

import UIKit
import SnapKit

class MainView: UIView {

    // MARK: - 스크롤뷰
        let scrollView = UIScrollView()
        let contentView = UIView()
    
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
    private lazy var locationLabel = boldSystemFontLabel("나의 위치", 32, .white)
    private lazy var humidityLabel = boldSystemFontLabel("습도", 16, .white)
    private lazy var sunriseLabel = boldSystemFontLabel("일출", 16, .white)
    private lazy var sunsetLabel = boldSystemFontLabel("일몰", 16, .white)
    
    // 변동사항 있음
    private lazy var locationDetailLabel = systemFontLabel("서울시", 16, .white)
    private lazy var temperatureLabel = boldSystemFontLabel("30°C", 48, .white)
    private lazy var descriptionLabel = systemFontLabel("바다 속 보다 더 촉촉함", 16, .white)
    private lazy var humidityDetailLabel = systemFontLabel("70%", 48, .white)
    private lazy var sunriseDetailLabel = boldSystemFontLabel("05:38", 16, .white)
    private lazy var sunsetDetailLabel = boldSystemFontLabel("19:56", 16, .white)
    
    // MARK: - 배경이미지
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.alpha = 0.4
        imageView.image = UIImage(named: "rain") // 배경 이미지 설정
        return imageView
    }()
    
    // MARK: - 섹션별 뷰
    private lazy var topView = UIView()
    private lazy var midView = UIView()
    private lazy var humidityContainer = UIView()
    private lazy var sunriseSunsetContainer = UIView()
    
    // MARK: - 테이블 뷰
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        tableView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.isScrollEnabled = false
        
        tableView.separatorStyle = .singleLine // 기본 선 스타일
        tableView.separatorColor = .white // 구분선 색상
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15) // 좌우 여백
        return tableView
    }()
    
    // MARK: - 컬렉션 뷰
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        collectionView.layer.cornerRadius = 10
        return collectionView
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
        backgroundLayout()
        setupScrollViewLayout()
        setupTopViewLayout()
        setupMidViewLayout()
        setupCollectionViewLayout()
        setupTableViewLayout()
    }
    
    private func configureUI() {
        configureTopViewLayout()
        configureMidViewLayout()
        configureTableViewHeader()
    }
    
    // MARK: - 스크롤뷰 레이아웃 설정
    private func setupScrollViewLayout() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(84)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    // MARK: - 백그라운드 이미지 뷰 레이아웃
    private func backgroundLayout() {
        // 백그라운드 이미지뷰를 메인 뷰에 추가
        self.addSubview(backgroundImageView)
        
        // 다른 뷰들을 추가하기 전에 백그라운드 이미지 뷰를 뒤에 배치
        [topView, midView].forEach {
            contentView.addSubview($0)
        }
        
        // backgroundImageView 제약 조건 설정
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview() // 슈퍼뷰(메인 뷰)에 맞추기
        }
    }
    
    // MARK: - 상단, 중간 뷰 레이아웃
    private func setupTopViewLayout() {
        [topView, midView].forEach {
            contentView.addSubview($0)
        }
        
        // 상단 섹션 뷰
        topView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(216)
        }
        
        // 중단 섹션 뷰
        midView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(20)
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
        
        // 일몰, 일출 레이블 스택뷰
        sunriseSunsetContainer.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(136)
            $0.width.equalTo(168)
        }
        
        // 스택뷰 디테일
        humidityContainer.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        sunriseSunsetContainer.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        humidityContainer.layer.cornerRadius = 10
        sunriseSunsetContainer.layer.cornerRadius = 10
    }
    
    // MARK: - 테이블 뷰 레이아웃
    private func setupTableViewLayout() {
        contentView.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(279)
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
    
    // MARK: - 컬렉션 뷰 레이아웃
    private func setupCollectionViewLayout() {
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(midView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(120)
        }
    }
    
    // MARK: - 상단 뷰 디테일
    private func configureTopViewLayout() {
        [locationLabel, locationDetailLabel, temperatureLabel, descriptionLabel].forEach {
            topView.addSubview($0)
        }
        
        locationLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        locationDetailLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(locationDetailLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-24)
        }
    }
    
    // MARK: - 중단 뷰 디테일
    private func configureMidViewLayout() {
        [humidityLabel, humidityDetailLabel].forEach {
            humidityContainer.addSubview($0)
        }
        
        humidityLabel.snp.makeConstraints {
            $0.bottom.equalTo(humidityDetailLabel.snp.top).offset(-16)
            $0.centerX.equalTo(humidityDetailLabel.snp.centerX)
            $0.height.equalTo(16)
        }
        
        humidityDetailLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(10)
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
        headerView.backgroundColor = .clear
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

