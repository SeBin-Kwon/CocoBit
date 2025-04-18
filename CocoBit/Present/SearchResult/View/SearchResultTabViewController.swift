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

final class SearchResultTabViewController: TabmanViewController {
    
    private let disposeBag = DisposeBag()
    
    private var viewControllers = [UIViewController]()

    private let searchTextField = {
        let textfield = UITextField()
        textfield.textColor = .cocoBitBlack
        textfield.frame = CGRect(x: 0, y: 0, width: 300, height: 30)
        return textfield
    }()
    private let viewModel = SearchResultTabViewModel()
    let vc = SearchResultViewController()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBaseSetting()
        configureNavigationBar()
        configureTabView()
        bind()
    }
    
    private func bind() {
        
        let input = SearchResultTabViewModel.Input(
            searchButtonTap: searchTextField.rx.controlEvent(.editingDidEndOnExit),
            searchText: searchTextField.rx.text
        )
        _ = viewModel.transform(input: input)
        
        SearchState.shared.searchText
            .bind(to:searchTextField.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    private func configureNavigationBar() {
        navigationItem.leftItemsSupplementBackButton = true
        let textField = UIBarButtonItem(customView: searchTextField)
        navigationItem.leftBarButtonItem = textField
    }
    
}

// MARK: TabView
extension SearchResultTabViewController {
    private func configureTabView() {
        [vc, UIViewController(), UIViewController()].forEach {
            viewControllers.append($0)
        }
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
        
        bar.backgroundView.style = .clear
        bar.backgroundColor = .white
        
        bar.buttons.customize{
            (button)
            in
            button.tintColor = .cocoBitGray
            button.selectedTintColor = .cocoBitBlack
            button.font = UIFont.setFont(.subTitle)
        }
        
        let underLine = UIView()
        underLine.backgroundColor = .cocoBitGray
        bar.backgroundView.addSubview(underLine)
        
        underLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(bar.backgroundView)
            make.bottom.equalTo(bar.backgroundView)
        }
        
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.overscrollBehavior = .bounce
        bar.indicator.tintColor = .cocoBitBlack
        
        addBar(bar, dataSource: self, at: .top)
    }
}

extension SearchResultTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0: return TMBarItem(title: "코인")
        case 1: return TMBarItem(title: "NFT")
        case 2: return TMBarItem(title: "거래소")
        default: return TMBarItem(title: "Page")
        }
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
