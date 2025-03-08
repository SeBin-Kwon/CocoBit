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
        
        let tradeSortState = BehaviorRelay<Bool?>(value: nil)
        let changeSortState = BehaviorRelay<Bool?>(value: nil)
        let priceSortState = BehaviorRelay<Bool?>(value: nil)
        
        let input = ExchangeViewModel.Input(
            tradeButtonTap: headerView.tradeButton.rx.tap,
            tradeButtonState: tradeSortState,
            changeButtonTap: headerView.changeButton.rx.tap,
            changeButtonState: changeSortState,
            priceButtonTap: headerView.priceButton.rx.tap,
            priceButtonState: priceSortState
        )
        
        let output = viewModel.transform(input: input)
        
        output.marketList
            .drive(tableView.rx.items(cellIdentifier: ExchangeTableViewCell.identifier, cellType: ExchangeTableViewCell.self)) { row, element, cell in
                cell.coinLabel.text = element.market
                cell.tradeLabel.text = element.tradePrice
                cell.changeRateLabel.text = element.signedChangeRate.0
                cell.changeRateLabel.textColor = element.signedChangeRate.1.color
                cell.changePriceLabel.text = element.signedChangePrice.0
                cell.changePriceLabel.textColor = element.signedChangePrice.1.color
                cell.priceLabel.text = element.accTradePrice24h
            }
            .disposed(by: disposeBag)
        
        output.tradeSorted
            .drive(with: self) { owner, value in
                owner.headerView.tradeButton.sortState = value
                tradeSortState.accept(value)
            }
            .disposed(by: disposeBag)
        
        output.changeSorted
            .drive(with: self) { owner, value in
                owner.headerView.changeButton.sortState = value
                changeSortState.accept(value)
            }
            .disposed(by: disposeBag)
        
        output.priceSorted
            .drive(with: self) { owner, value in
                owner.headerView.priceButton.sortState = value
                priceSortState.accept(value)
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
