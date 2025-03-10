//
//  DetailCollectionViewCell.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/10/25.
//

import UIKit
import SnapKit

class DetailCollectionViewCell: BaseCollectionViewCell {
    
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
    
    let containerView = UIView()
    
    override func configureHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubviews(nameLabel, valueLabel)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel)
            make.bottom.equalTo(valueLabel)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.bottom.leading.equalToSuperview()
        }
    }
}
