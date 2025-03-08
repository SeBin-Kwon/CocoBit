//
//  ExchangeTableViewCell.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/6/25.
//


import UIKit
import SnapKit

class ExchangeTableViewCell: BaseTableViewCell {
    
    let coinLabel = {
        let label = UILabel()
        label.text = "XRP/KRW"
        label.font = .setFont(.mediumBold)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let tradeLabel = {
        let label = UILabel()
        label.text = "3,868"
        label.font = .setFont(.medium)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let changeRateLabel = {
        let label = UILabel()
        label.text = "3,868"
        label.font = .setFont(.medium)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let changePriceLabel = {
        let label = UILabel()
        label.text = "3,868"
        label.font = .setFont(.small)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let priceLabel = {
        let label = UILabel()
        label.text = "3,868"
        label.font = .setFont(.medium)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    func configureData(_ element: MarketFormatted) {
        coinLabel.text = element.market
        tradeLabel.text = element.tradePrice
        changeRateLabel.text = element.signedChangeRate.0
        changeRateLabel.textColor = element.signedChangeRate.1.color
        changePriceLabel.text = element.signedChangePrice.0
        changePriceLabel.textColor = element.signedChangePrice.1.color
        priceLabel.text = element.accTradePrice24h
    }

    override func configureHierarchy() {
        contentView.addSubviews(coinLabel, priceLabel, changeRateLabel, changePriceLabel, tradeLabel)
    }
    
    override func configureLayout() {
        coinLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.centerY.equalToSuperview()
        }
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
            make.centerY.equalToSuperview()
        }
        changeRateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-120)
            make.centerY.equalToSuperview()
        }
        changePriceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-120)
            make.top.equalTo(changeRateLabel.snp.bottom)
        }
        tradeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-200)
            make.centerY.equalToSuperview()
        }
    }

}
