//
//  AddRegionViewController.swift
//  WeatherApp
//
//  Created by pc on 8/19/24.
//

import UIKit
import SnapKit


class AddRegionViewController: UIViewController {
    private let addRegionView: MainView = {
        let view = MainView()
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    private func bind() {
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        view.addSubview(addRegionView)
        addRegionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
