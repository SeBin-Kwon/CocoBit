//
//  UIViewController+Extension.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/9/25.
//

import UIKit
import Toast

extension UIViewController {
    func navigate(_ type: NavigationType) {
        switch type {
        case .push(let vc): self.navigationController?.pushViewController(vc, animated: true)
        case .pop: self.navigationController?.popViewController(animated: true)
        case .present(let vc): self.present(vc, animated: true)
        case .dismiss: self.dismiss(animated: true)
        }
    }
    
    func toast(_ value: Bool, _ name: String) {
        if value {
            view.makeToast("\(name)(이/가) 즐겨찾기되었습니다.")
        } else {
            view.makeToast("\(name)(이/가) 즐겨찾기에서 제거되었습니다.")
        }
    }
}

enum NavigationType {
    case push(UIViewController)
    case pop
    case present(UIViewController)
    case dismiss
}
