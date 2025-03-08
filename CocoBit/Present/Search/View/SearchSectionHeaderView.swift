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
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(10)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
