//
//  StarButton.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/11/25.
//

import UIKit

final class LikeButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var config = UIButton.Configuration.filled()
        config.image = .setSymbol(.star)
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .cocoBitBlack
        config.buttonSize = .mini
        config.cornerStyle = .capsule
        configurationUpdateHandler = { btn in
            switch btn.state {
            case .normal:
                self.configuration?.image = .setSymbol(.star)
            case .selected:
                self.configuration?.image = .setSymbol(.starFill)
            default:
                return
            }
        }
        configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
