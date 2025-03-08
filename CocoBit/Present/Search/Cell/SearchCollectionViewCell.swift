//
//  SearchCollectionViewCell.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/8/25.
//

import UIKit
import SnapKit

class SearchCollectionViewCell: BaseCollectionViewCell {
    
    let scoreLabel = {
        let label = UILabel()
        label.text = "1"
        label.font = .setFont(.medium)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let symbolLabel = {
        let label = UILabel()
        label.text = "SYMBOL"
        label.font = .setFont(.mediumBold)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let nameLabel = {
        let label = UILabel()
        label.text = "name"
        label.font = .setFont(.small)
        label.textColor = .cocoBitGray
        return label
    }()
    
    let imageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        image.contentMode = .scaleAspectFill
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
    
    func configureData(_ item: CoinItem) {
        scoreLabel.text = item.score
        symbolLabel.text = item.symbol
        nameLabel.text = item.name
//        changeLabel.text = item.change
    }
    
    override func configureHierarchy() {
        contentView.addSubviews(scoreLabel, symbolLabel, nameLabel, imageView, changeLabel)
    }
    
    override func configureLayout() {
        scoreLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(26)
        }
        symbolLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView)
            make.leading.equalTo(imageView.snp.trailing).offset(5)
        }
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView)
            make.leading.equalTo(imageView.snp.trailing).offset(5)
        }
        changeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        DispatchQueue.main.async {
            self.imageView.layer.cornerRadius = self.imageView.frame.height / 2
        }
    }
}
