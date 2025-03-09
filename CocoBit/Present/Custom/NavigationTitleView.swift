//
//  NavigationTitleView.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/6/25.
//

import UIKit
import SnapKit

final class NavigationTitleView: BaseView {
    
    let title: String
    
    lazy var titleLabel = {
        let label = UILabel()
        label.text = title
        label.font = .setFont(.navTitle)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
    }
    
    override func configureHierarchy() {
        addSubview(titleLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
}
