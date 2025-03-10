//
//  DetailSectionHeaderView.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/11/25.
//

import UIKit

final class DetailSectionHeaderView: UICollectionReusableView {
    static var identifier: String {
        String(describing: self)
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .setFont(.subTitle)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let moreButton = MoreButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        addSubviews(titleLabel, moreButton)
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview()
        }
    }
}
