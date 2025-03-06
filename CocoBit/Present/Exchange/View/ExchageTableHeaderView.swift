//
//  ExchageTableHeaderView.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/6/25.
//

import UIKit
import SnapKit

final class ExchangeTableHeaderView: BaseView {
    
    let coinLabel = {
        let label = UILabel()
        label.text = "코인"
        label.font = .setFont(.mediumBold)
        label.textColor = .cocoBitBlack
        return label
    }()
    
//    let tradeLabel = {
//        let label = UILabel()
//        label.text = "3,868"
//        label.font = .setFont(.medium)
//        label.textColor = .cocoBitBlack
//        return label
//    }()
    
    let tradeButton = ExchageSortButton(title: "현재가")
    
    let changeButton = ExchageSortButton(title: "전일대비")
    
    let priceButton = ExchageSortButton(title: "거래대금")
    
    override func configureHierarchy() {
        backgroundColor = .cocoBitLightGray
        addSubviews(coinLabel, priceButton, changeButton, tradeButton)
    }
    
    override func configureLayout() {
        coinLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.centerY.equalToSuperview()
        }
        priceButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalToSuperview()
        }
        changeButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-120)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalToSuperview()
        }
        tradeButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-200)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalToSuperview()
        }
    }
}
