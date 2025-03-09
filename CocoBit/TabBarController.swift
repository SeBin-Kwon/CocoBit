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
        
        let searchNav = UINavigationController(rootViewController: SearchViewController())
        searchNav.tabBarItem = UITabBarItem(title: "코인정보", image: .setSymbol(.chartBar), tag: 1)
        
        let emptyNav = UINavigationController(rootViewController: EmptyViewController())
        emptyNav.tabBarItem = UITabBarItem(title: "포트폴리오", image: .setSymbol(.star), tag: 2)
        
        setViewControllers([exchangeNav, searchNav, emptyNav], animated: true)
        
        tabBar.tintColor = .cocoBitBlack
        tabBar.unselectedItemTintColor = .lightGray
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
