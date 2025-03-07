//
//  ExchageSortButton.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/6/25.
//

import UIKit
import SnapKit

final class ExchangeSortButton: UIButton {
    
    let title: String
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLable = {
        let label = UILabel()
        label.text = title
        label.font = .setFont(.mediumBold)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let arrowUp = {
        let image = UIImageView()
        image.image = .setSymbol(.arrowUp)
        image.tintColor = .cocoBitBlack
        return image
    }()
    
    let arrowDown = {
        let image = UIImageView()
        image.image = .setSymbol(.arrowDown)
        image.tintColor = .cocoBitBlack
        return image
    }()

    private func configureHierarchy() {
        addSubviews(titleLable, arrowUp, arrowDown)
    }
    
    private func configureLayout() {
        titleLable.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        arrowUp.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.top)
            make.leading.equalTo(titleLable.snp.trailing).offset(2)
            make.width.equalTo(5)
            make.height.equalTo(9)
        }
        arrowDown.snp.makeConstraints { make in
            make.bottom.equalTo(titleLable.snp.bottom)
            make.leading.equalTo(titleLable.snp.trailing).offset(2)
            make.width.equalTo(5)
            make.height.equalTo(9)
        }
    }

}
