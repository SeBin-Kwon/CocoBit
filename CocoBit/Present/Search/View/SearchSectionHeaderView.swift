//
//  SearchSectionHeaderView.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/8/25.
//

import UIKit

final class SearchSectionHeaderView: UICollectionReusableView {
    static var identifier: String {
        String(describing: self)
    }
    
    let titleLabel: UILabel = {
            let label = UILabel()
        label.font = .setFont(.subTitle)
        label.textColor = .cocoBitBlack
            return label
        }()
    
    let timeLabel = {
        let label = UILabel()
        label.font = .setFont(.medium)
        label.textColor = .cocoBitGray
        return label
    }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            configureHierarchy()
            configureLayout()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    private func configureHierarchy() {
        addSubviews(titleLabel, timeLabel)
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(10)
        }
    }
}
