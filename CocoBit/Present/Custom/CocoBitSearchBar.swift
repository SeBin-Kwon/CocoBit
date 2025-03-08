//
//  CocoBitSearchBar.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/8/25.
//

import UIKit
import SnapKit

final class CocoBitSearchBar: BaseView {
    
    private let borderView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.cocoBitGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let searchBar = {
        let search = UISearchBar()
        
        search.searchBarStyle = .minimal
        search.searchTextField.textColor = .cocoBitBlack
        if let subView = search.searchTextField.subviews.first {
            subView.isHidden = true
        }
        search.searchTextField.attributedPlaceholder = NSAttributedString(string: "검색어를 입력해주세요.", attributes: [.foregroundColor: UIColor.cocoBitGray, .font: UIFont.systemFont(ofSize: 15)])
        search.searchTextField.leftView?.tintColor = .cocoBitGray
        
        return search
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
    }

    
    override func configureHierarchy() {
        addSubviews(borderView, searchBar)
    }
    
    override func configureLayout() {
        borderView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(5)
        }
        searchBar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderView.layer.cornerRadius = borderView.frame.height / 2
    }
}
