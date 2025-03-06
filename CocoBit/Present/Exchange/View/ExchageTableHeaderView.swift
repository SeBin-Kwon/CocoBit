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
    
    let tradeLabel = {
        let label = UILabel()
        label.text = "3,868"
        label.font = .setFont(.medium)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let changeLabel = {
        let label = UILabel()
        label.text = "3,868"
        label.font = .setFont(.medium)
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
    
    override func configureHierarchy() {
        backgroundColor = .cocoBitLightGray
        addSubviews(coinLabel, priceLabel, changeLabel, tradeLabel)
    }
    
    override func configureLayout() {
        coinLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.centerY.equalToSuperview()
        }
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            make.centerY.equalToSuperview()
        }
        changeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-80)
            make.centerY.equalToSuperview()
        }
        tradeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-180)
            make.centerY.equalToSuperview()
        }
    }
}
