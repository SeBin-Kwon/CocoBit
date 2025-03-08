//
//  SearchViewController.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/6/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchViewController: BaseViewController {
    
    private let searchBar = CocoBitSearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = NavigationTitleView(title: "가상자산 / 심볼 검색")
        configureHierarchy()
        configureLayout()
    }

}

extension SearchViewController {
    private func configureHierarchy() {
        view.addSubviews(searchBar)
    }
    
    private func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
