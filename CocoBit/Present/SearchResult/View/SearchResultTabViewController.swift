//
//  SearchResultTabViewController.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/10/25.
//

import UIKit
import Tabman
import Pageboy

class SearchResultTabViewController: TabmanViewController {
    
    private var viewControllers = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBaseSetting()
        viewControllers.append(SearchResultViewController(searchText: "sds"))
        viewControllers.append(UIViewController())
        viewControllers.append(UIViewController())
        
        self.dataSource = self

        // Create bar
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap // Customize

        // Add to view
        addBar(bar, dataSource: self, at: .top)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SearchResultTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: "")
        item.title = "Page \(index)"
        
        return item
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}

extension SearchResultTabViewController {
    private func configureBaseSetting() {
        view.backgroundColor = .white
        let appearance = UINavigationBarAppearance()
        appearance.setBackIndicatorImage(.setSymbol(.arrowLeft)?.withTintColor(UIColor.cocoBitBlack, renderingMode: .alwaysOriginal), transitionMaskImage: .setSymbol(.arrowLeft))
        appearance.backgroundColor = .white
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.backButtonTitle = ""
    }
}
