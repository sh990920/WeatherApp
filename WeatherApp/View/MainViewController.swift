//
//  ViewController.swift
//  WeatherApp
//
//  Created by 박승환 on 8/12/24.
//

import UIKit

class MainViewController: UIViewController {

    private let mainView = MainView()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        mainView.backgroundColor = .white
    }

}
