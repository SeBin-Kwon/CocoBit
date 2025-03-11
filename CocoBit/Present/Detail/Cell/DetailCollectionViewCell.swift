//
//  DetailCollectionViewCell.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/10/25.
//

import UIKit
import SnapKit

final class DetailCollectionViewCell: BaseCollectionViewCell {
    
    let nameLabel = {
        let label = UILabel()
        label.font = .setFont(.medium)
        label.textColor = .cocoBitGray
        return label
    }()
    
    let valueLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let dateLabel = {
        let label = UILabel()
        label.font = .setFont(.small)
        label.textColor = .cocoBitGray
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 3
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        return stack
    }()
    
    func configureStockData(_ item: StockItem) {
        nameLabel.text = item.title
        valueLabel.text = item.value
        dateLabel.text = item.date
    }
    
    func configureInvestmentData(_ item: InvestmentItem) {
        nameLabel.text = item.title
        valueLabel.text = item.value
    }
    
    override func configureHierarchy() {
        contentView.addSubview(stackView)
        [nameLabel, valueLabel, dateLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        layer.cornerRadius = 20
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
    }
}
