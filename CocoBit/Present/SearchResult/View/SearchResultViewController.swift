//
//  SearchResultViewController.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/9/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class SearchTextFieldView: BaseView {
    let textField = {
        let textfield = UITextField()
        textfield.backgroundColor = .red
        return textfield
    }()
    
    override func configureHierarchy() {
        addSubview(textField)
    }
    
    override func configureLayout() {
        textField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
    }
}



final class SearchResultViewController: BaseViewController {
    
    let searchText: String
    let searchTextField = {
        let textfield = UITextField()
        textfield.textColor = .cocoBitBlack
        textfield.frame = CGRect(x: 0, y: 0, width: 300, height: 30)
        return textfield
    }()
    
    init(searchText: String) {
        self.searchText = searchText
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
    }
    
    

}


// MARK: View Layout
extension SearchResultViewController {
    private func configureNavigationBar() {
        searchTextField.text = searchText
        navigationItem.leftItemsSupplementBackButton = true
        let textField = UIBarButtonItem(customView: searchTextField)
        navigationItem.leftBarButtonItem = textField
    }
    
    private func configureHierarchy() {
        
    }
    
    private func configureLayout() {
        
    }
}
