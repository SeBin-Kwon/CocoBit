//
//  DetailCollectionViewCell.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/10/25.
//

import UIKit
import SnapKit

class DetailStockCollectionViewCell: BaseCollectionViewCell {
    
    let nameLabel = {
        let label = UILabel()
        label.text = "sdfsdafesfsfd"
        label.font = .setFont(.medium)
        label.textColor = .cocoBitGray
        return label
    }()
    
    let valueLabel = {
        let label = UILabel()
        label.text = "32341484191"
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let dateLabel = {
        let label = UILabel()
        label.text = "12년 3월 30일"
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
    
    
    override func configureHierarchy() {
        contentView.addSubview(stackView)
        [nameLabel, valueLabel, dateLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
    }
}
