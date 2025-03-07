//
//  DecimalState.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/7/25.
//

import UIKit

enum DecimalState {
    case up
    case down
    case zero
    
    var color: UIColor {
        switch self {
        case .up: .cocoBitRed
        case .down: .cocoBitBlue
        case .zero: .cocoBitBlack
        }
    }
}

