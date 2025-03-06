//
//  ExchangeViewController.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/6/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ExchangeViewController: BaseViewController {
    
    let tableView = {
       let view = UITableView()
        view.register(ExchangeTableViewCell.self, forCellReuseIdentifier: ExchangeTableViewCell.identifier)
        view.backgroundColor = .lightGray
        view.rowHeight = 50
        view.separatorStyle = .none
        return view
    }()
    
    let headerView = ExchangeTableHeaderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = NavigationTitleView(title: "거래소")
        configureLayout()
        bind()
    }
    
    private func bind() {
        let list = Observable.just(["ser", "serewe", "wer"])
        
        list
            .bind(to: tableView.rx.items(cellIdentifier: ExchangeTableViewCell.identifier, cellType: ExchangeTableViewCell.self)) { row, element, cell in
                cell.coinLabel.text = element
                cell.changeLabel.text = element
            }
            .disposed(by: disposeBag)
    }
    
    private func configureLayout() {
        view.addSubviews(tableView, headerView)
        headerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}
