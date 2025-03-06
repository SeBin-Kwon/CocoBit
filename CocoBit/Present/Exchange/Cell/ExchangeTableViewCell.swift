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
    
    let currentLabel = {
        let label = UILabel()
        label.text = "3,868"
        label.font = .setFont(.medium)
        label.textColor = .cocoBitBlack
        return label
    }()

    override func configureHierarchy() {
        addSubviews(coinLabel, currentLabel)
    }
    
    override func configureLayout() {
        coinLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.centerY.equalToSuperview()
        }
        currentLabel.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            make.centerY.equalToSuperview()
        }
    }

}
