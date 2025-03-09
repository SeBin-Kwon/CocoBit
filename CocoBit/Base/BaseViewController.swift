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
        appearance.setBackIndicatorImage(.setSymbol(.arrowLeft), transitionMaskImage: .setSymbol(.arrowLeft))
        appearance.backgroundColor = .white
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.backButtonTitle = ""
        navigationItem.backBarButtonItem?.tintColor = UIColor.cocoBitBlack
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
