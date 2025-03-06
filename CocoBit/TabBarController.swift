//
//  TabBarController.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/6/25.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarController()
    }
    
    private func configureTabBarController() {
        let exchangeNav = UINavigationController(rootViewController: ExchangeViewController())
        exchangeNav.tabBarItem = UITabBarItem(title: "거래소", image: .setSymbol(.chartLineUP), tag: 0)
        setViewControllers([exchangeNav], animated: true)
    }
}
