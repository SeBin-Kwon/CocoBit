//
//  PopUpView.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/11/25.
//

import UIKit
import SnapKit

class PopUpView: BaseView {
    
    let titleLabel = {
        let label = UILabel()
        label.text = "안내"
        label.font = .setFont(.subTitle)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let messageLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .cocoBitBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let retryButton = {
        var config = UIButton.Configuration.plain()
        var attributedTitle = AttributedString("다시 시도하기")
        attributedTitle.font = UIFont.setFont(.subTitle)
        attributedTitle.foregroundColor = UIColor.cocoBitBlack
        config.attributedTitle = attributedTitle
        let btn = UIButton(configuration: config)
        return btn
    }()
    
    let lineView = {
        let view = UIView()
        view.backgroundColor = .cocoBitLightGray
        return view
    }()
    

    override func configureHierarchy() {
        addSubviews(titleLabel, messageLabel, retryButton, lineView)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        retryButton.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(retryButton)
        }
    }

}
