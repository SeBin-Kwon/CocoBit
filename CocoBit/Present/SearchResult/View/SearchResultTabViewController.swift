//
//  SearchResultTabViewController.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/10/25.
//

import UIKit
import RxSwift
import RxCocoa
import Tabman
import Pageboy

class SearchResultTabViewController: TabmanViewController {
    
    let disposeBag = DisposeBag()
    
    private var viewControllers = [UIViewController]()
    private let searchText: String
    private let searchTextField = {
        let textfield = UITextField()
        textfield.textColor = .cocoBitBlack
        textfield.frame = CGRect(x: 0, y: 0, width: 300, height: 30)
        return textfield
    }()
    
    let vc = SearchResultViewController()
    
    init(searchText: String) {
        self.searchText = searchText
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBaseSetting()
        configureNavigationBar()

        vc.viewModel.searchText.accept(searchText)
        
        viewControllers.append(vc)
        viewControllers.append(UIViewController())
        viewControllers.append(UIViewController())
        
        self.dataSource = self

        // Create bar
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap // Customize

        // Add to view
        addBar(bar, dataSource: self, at: .top)
        
        bind()
    }
    
    private func bind() {
        
        searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(searchTextField.rx.text)
            .bind(with: self) { owner, value in
                owner.vc.viewModel.searchText.accept(value ?? "")
            }
            .disposed(by: disposeBag)
        
    }
    
    private func configureNavigationBar() {
        searchTextField.text = searchText
        navigationItem.leftItemsSupplementBackButton = true
        let textField = UIBarButtonItem(customView: searchTextField)
        navigationItem.leftBarButtonItem = textField
    }

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
