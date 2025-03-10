//
//  DetailTitleView.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/10/25.
//

import UIKit
import SnapKit

final class DetailTitleView: BaseView {
    
    let imageView = {
        let image = UIImageView()
        image.backgroundColor = .cocoBitLightGray
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let nameLabel = {
        let label = UILabel()
        label.text = "BTC"
        label.font = .setFont(.subTitle)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let stackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 5
        view.alignment = .center
        view.distribution = .fillProportionally
        return view
    }()
    
    override func configureHierarchy() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(nameLabel)
        addSubview(stackView)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(26)
        }
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        DispatchQueue.main.async {
            self.imageView.layer.cornerRadius = self.imageView.frame.height / 2
        }
    }
}
