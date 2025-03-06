//
//  NavigationTitleView.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/6/25.
//

import UIKit

final class NavigationTitleView: UIView {
    
    let title: String
    
    lazy var titleLable = {
        let label = UILabel()
        label.text = title
        label.font = .setFont(.navTitle)
        return label
    }()
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        addSubview(titleLable)
        titleLable.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(-180)
            make.top.equalToSuperview().offset(10)
        }
    }
    
}
