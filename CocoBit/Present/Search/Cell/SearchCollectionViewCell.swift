//
//  SearchCollectionViewCell.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/8/25.
//

import UIKit
import SnapKit
import Kingfisher

class SearchCollectionViewCell: BaseCollectionViewCell {
    
    let scoreLabel = {
        let label = UILabel()
        label.font = .setFont(.medium)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let symbolLabel = {
        let label = UILabel()
        label.font = .setFont(.mediumBold)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let nameLabel = {
        let label = UILabel()
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
        label.font = .setFont(.smallBold)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    func configureData(_ item: CoinItem) {
        scoreLabel.text = item.score
        symbolLabel.text = item.symbol
        nameLabel.text = item.name
        changeLabel.text = item.change
        let url = URL(string: item.image)
        imageView.kf.setImage(with: url)
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
            make.trailing.equalToSuperview().inset(45)
        }
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView)
            make.leading.equalTo(imageView.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(45)
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
