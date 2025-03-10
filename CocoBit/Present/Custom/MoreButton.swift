//
//  MoreButton.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/11/25.
//

import UIKit
import SnapKit

final class MoreButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var config = UIButton.Configuration.plain()
        var attributedTitle = AttributedString("더보기")
        attributedTitle.font = .systemFont(ofSize: 12)
        config.attributedTitle = attributedTitle
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular, scale: .default)
        let image = UIImage(systemName: "chevron.right", withConfiguration: symbolConfig)
        config.image = image
        config.baseForegroundColor = .cocoBitGray
        config.imagePlacement = .trailing
        config.buttonSize = .mini
        config.contentInsets = .zero
        configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
