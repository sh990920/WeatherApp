//
//  AddRegionViewController.swift
//  WeatherApp
//
//  Created by pc on 8/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AddRegionViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let addRegionView: MainView = {
        let view = MainView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
        bindButtons()
    }
    
    private func bindButtons() {
        guard let addButton = navigationItem.rightBarButtonItem,
              let cancelButton = navigationItem.leftBarButtonItem else { return }
        
        addButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        view.addSubview(addRegionView)
        addRegionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: nil)
    }
}
