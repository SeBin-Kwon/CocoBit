//
//  SearchViewController.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/6/25.
//

import UIKit

final class SearchViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = NavigationTitleView(title: "가상자산 / 심볼 검색")
    }

}
