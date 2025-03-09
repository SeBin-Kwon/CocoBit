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
        label.font = .setFont(.smallBold)
        label.textColor = .cocoBitBlack
        label.textAlignment = .center
        return label
    }()
    
    let priceLabel = {
        let label = UILabel()
        label.font = .setFont(.small)
        label.textColor = .cocoBitGray
        return label
    }()
    
    let imageView = {
        let image = UIImageView()
        image.backgroundColor = .cocoBitLightGray
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        return image
    }()
    
    let changeView = TrendingChangeLableView()
    
    
    func configureData(_ item: NFTItem) {
        nameLabel.text = item.name
        priceLabel.text = item.price
        changeView.changeLabel.text = item.change
        changeView.changeLabel.textColor = item.changeColor.color
        changeView.arrowImage.tintColor = item.changeColor.color
        
        let url = URL(string: item.image)
        imageView.kf.setImage(with: url)
        
        switch item.changeColor {
        case .down: changeView.arrowImage.image = .setSymbol(.arrowDown)
        case .up: changeView.arrowImage.image = .setSymbol(.arrowUp)
        default: break
        }
    }
    
    override func configureHierarchy() {
        contentView.addSubviews(nameLabel, priceLabel, imageView, changeView)
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
            make.width.equalTo(imageView)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
        }
        changeView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
        }
    }
}
