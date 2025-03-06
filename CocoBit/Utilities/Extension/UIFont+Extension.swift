//
//  UIFont+Extension.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/6/25.
//

import UIKit

extension UIFont {
    static func setFont(_ type: Font) -> UIFont {
        switch type {
        case .medium: UIFont.systemFont(ofSize: 12)
        case .small: UIFont.systemFont(ofSize: 9)
        case .mediumBold: UIFont.systemFont(ofSize: 12, weight: .bold)
        case .smallBold: UIFont.systemFont(ofSize: 9, weight: .bold)
        case .navTitle: UIFont.systemFont(ofSize: 18, weight: .bold)
        case .subTitle: UIFont.systemFont(ofSize: 14, weight: .bold)
        }
    }
}
