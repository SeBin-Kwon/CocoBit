//
//  TrendingChangeLableView.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/9/25.
//

import UIKit

final class TrendingChangeLableView: BaseView {
    
    let changeLabel = {
        let label = UILabel()
        label.font = .setFont(.smallBold)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let arrowImage = UIImageView()
    
    private let stackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 4
        return view
    }()
    
    override func configureHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubview(arrowImage)
        stackView.addArrangedSubview(changeLabel)
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        arrowImage.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.width.equalTo(8)
        }
    }
}
