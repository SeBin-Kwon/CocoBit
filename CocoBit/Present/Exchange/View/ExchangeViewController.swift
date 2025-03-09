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
        view.backgroundColor = .cocoBitLightGray
        view.rowHeight = 50
        view.separatorStyle = .none
        return view
    }()
    
    let headerView = ExchangeTableHeaderView()
    let viewModel = ExchangeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        bind()
    }
    
    private func bind() {
        
        let tradeSortState = BehaviorRelay<Bool?>(value: nil)
        let changeSortState = BehaviorRelay<Bool?>(value: nil)
        let priceSortState = BehaviorRelay<Bool?>(value: nil)
        
        let input = ExchangeViewModel.Input(
            tradeButtonTap: (headerView.tradeButton.rx.tap, tradeSortState),
            changeButtonTap: (headerView.changeButton.rx.tap, changeSortState),
            priceButtonTap: (headerView.priceButton.rx.tap, priceSortState)
        )
        
        let output = viewModel.transform(input: input)
        
        output.marketList
            .drive(tableView.rx.items(cellIdentifier: ExchangeTableViewCell.identifier, cellType: ExchangeTableViewCell.self)) { row, element, cell in
                cell.configureData(element)
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
}


extension ExchangeViewController {
    private func configureNavigationBar() {
        let titleView = UIBarButtonItem(customView: NavigationTitleView(title: "거래소"))
        navigationItem.leftBarButtonItem = titleView
    }
    
    private func configureHierarchy() {
        view.addSubviews(tableView, headerView)
    }
    
    private func configureLayout() {
        headerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
