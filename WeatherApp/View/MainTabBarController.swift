//
//  MainTabBarController.swift
//  WeatherApp
//
//  Created by 머성이 on 8/14/24.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainViewController = MainViewController()
        let searchViewController = SearchViewController()

        mainViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "sun.max"), tag: 0)
        searchViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "line.horizontal.3"), tag: 1)

        mainViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        searchViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        self.viewControllers = [mainViewController, searchViewController]

        setupTabBarAppearance()
    }

    private func setupTabBarAppearance() {
        // 탭바 백그라운드 색상
        tabBar.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        
        // 탭 바의 투명도 설정 (false로 설정하여 완전한 색상 적용)
        tabBar.isTranslucent = true
        
        // 선택된 아이템의 색상 설정
        tabBar.tintColor = .white
        
        // 선택되지 않은 아이템의 색상 설정
        tabBar.unselectedItemTintColor = .lightGray
        
        // 추가로 그림자나 배경 이미지가 필요 없을 경우
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
    }
}
