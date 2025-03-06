//
//  BaseViewController.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/6/25.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
//        appearance.titlePositionAdjustment = UIOffset(horizontal: 10, vertical: 10)
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
