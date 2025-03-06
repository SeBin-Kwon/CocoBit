//
//  UIImage+Extension.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/6/25.
//

import UIKit

extension UIImage {
    static func setSymbol(_ type: SFSymbol) -> UIImage? {
        UIImage(systemName: type.rawValue)
    }
}
