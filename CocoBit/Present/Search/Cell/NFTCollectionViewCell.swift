//
//  NFTCollectionViewCell.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/8/25.
//

import UIKit
import SnapKit
import Kingfisher

class NFTCollectionViewCell: BaseCollectionViewCell {
    
    let nameLabel = {
        let label = UILabel()
        label.text = "name"
        label.font = .setFont(.smallBold)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let priceLabel = {
        let label = UILabel()
        label.text = "0.66 SYMBOL"
        label.font = .setFont(.small)
        label.textColor = .cocoBitGray
        return label
    }()
    
    let imageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        return image
    }()
    
    let changeLabel = {
        let label = UILabel()
        label.text = "39.82%"
        label.font = .setFont(.smallBold)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    func configureData(_ item: NFTItem) {
        nameLabel.text = item.name
        priceLabel.text = item.price
        changeLabel.text = item.change
        let url = URL(string: item.image)
        imageView.kf.setImage(with: url)
        
    }
    
    override func configureHierarchy() {
        contentView.addSubviews(nameLabel, priceLabel, imageView, changeLabel)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(72)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
        }
        changeLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
        }
    }
}
