//
//  SearchResultCollectionViewCell.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/9/25.
//

import UIKit
import SnapKit

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
    
    let scoreLabel = {
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
    
    override func configureHierarchy() {
        addSubviews(imageView, symbolLabel, nameLabel, scoreBackgroundView, scoreLabel)
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
            make.width.equalTo(scoreLabel).offset(6)
            make.height.equalTo(scoreLabel).offset(4)
            make.leading.equalTo(symbolLabel.snp.trailing).offset(5)
            make.centerY.equalTo(symbolLabel)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.center.equalTo(scoreBackgroundView)
        }
        
        DispatchQueue.main.async {
            self.imageView.layer.cornerRadius = self.imageView.frame.height / 2
        }
    }
}
