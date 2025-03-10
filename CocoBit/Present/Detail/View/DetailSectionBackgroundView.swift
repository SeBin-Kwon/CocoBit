//
//  DetailSectionBackgroundView.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/10/25.
//

import UIKit
import SnapKit

final class DetailSectionBackgroundView: UICollectionReusableView {
    static var identifier: String {
        String(describing: self)
    }
    
    private let backgroundView = {
       let view = UIView()
        view.backgroundColor = .cocoBitLightGray
        view.layer.cornerRadius = 20
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(40)
//            make.horizontalEdges.equalToSuperview().inset(20)
//            make.bottom.equalToSuperview()
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
