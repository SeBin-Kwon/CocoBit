//
//  SearchResultCollectionViewCell.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/9/25.
//

import UIKit
import SnapKit
import Kingfisher

class SearchResultCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = {
        let image = UIImageView()
        image.backgroundColor = .cocoBitLightGray
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let symbolLabel = {
        let label = UILabel()
        label.text = "sdf"
        label.font = .setFont(.subTitle)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let nameLabel = {
        let label = UILabel()
        label.text = "sdf39239238492837"
        label.font = .setFont(.medium)
        label.textColor = .cocoBitGray
        return label
    }()
    
    let rankLabel = {
        let label = UILabel()
        label.text = "372333"
        label.font = .setFont(.smallBold)
        label.textColor = .cocoBitGray
        return label
    }()
    
    let scoreBackgroundView = {
        let view = UIView()
        view.backgroundColor = .cocoBitLightGray
        view.layer.cornerRadius = 3
        return view
    }()
    
    func configureData(_ item: SearchData) {
        symbolLabel.text = item.symbol
        nameLabel.text = item.name
        
        let url = URL(string: item.thumb)
        imageView.kf.setImage(with: url)
        
        guard let rank = item.rank else { return }
        rankLabel.text = "\(rank)"
    }
    
    override func configureHierarchy() {
        addSubviews(imageView, symbolLabel, nameLabel, scoreBackgroundView, rankLabel)
    }
    
    override func configureLayout() {
        
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(36)
        }
        
        symbolLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(45)
        }
        
        scoreBackgroundView.snp.makeConstraints { make in
            make.width.equalTo(rankLabel).offset(6)
            make.height.equalTo(rankLabel).offset(4)
            make.leading.equalTo(symbolLabel.snp.trailing).offset(5)
            make.centerY.equalTo(symbolLabel)
        }
        
        rankLabel.snp.makeConstraints { make in
            make.center.equalTo(scoreBackgroundView)
        }
        
        DispatchQueue.main.async {
            self.imageView.layer.cornerRadius = self.imageView.frame.height / 2
        }
    }
}
