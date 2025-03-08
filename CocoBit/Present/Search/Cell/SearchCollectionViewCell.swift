//
//  SearchCollectionViewCell.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/8/25.
//

import UIKit
import SnapKit

class SearchCollectionViewCell: BaseCollectionViewCell {
    let titleLabel = {
        let label = UILabel()
        label.text = "SearchCollectionViewCell"
        label.font = .setFont(.mediumBold)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubviews(titleLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
