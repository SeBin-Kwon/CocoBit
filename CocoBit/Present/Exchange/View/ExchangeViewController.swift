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
    
    let viewModel = ExchangeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = NavigationTitleView(title: "거래소")
        configureLayout()
        bind()
    }
    
    private func bind() {
        let input = ExchangeViewModel.Input(
            tradeButtonTap: headerView.tradeButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.marketList
            .drive(tableView.rx.items(cellIdentifier: ExchangeTableViewCell.identifier, cellType: ExchangeTableViewCell.self)) { row, element, cell in
                cell.coinLabel.text = "\(element.market)"
                cell.tradeLabel.text = "\(element.tradePrice)"
                cell.changeLabel.text = "\(element.signedChangeRate)"
                cell.priceLabel.text = "\(element.accTradePrice24h)"
            }
            .disposed(by: disposeBag)
        
//        output.tradeSorted
//            .drive { value in
//                print("현재가버튼", value)
//            }
//            .disposed(by: disposeBag)
        
        headerView.changeButton.rx.tap
            .bind { value in
                print("전일대비버튼", value)
            }
            .disposed(by: disposeBag)
        
        headerView.priceButton.rx.tap
            .bind { value in
                print("거래대금버튼", value)
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
