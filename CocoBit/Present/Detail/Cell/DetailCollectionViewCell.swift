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
        label.font = .setFont(.smallBold)
        label.textColor = .cocoBitBlack
        label.textAlignment = .center
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubviews(nameLabel)
    }
    
    override func configureLayout() {
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
