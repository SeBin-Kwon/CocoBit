//
//  BaseView.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/6/25.
//

import UIKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        
    }
    
    func configureHierarchy() {}
    func configureLayout() {}
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
