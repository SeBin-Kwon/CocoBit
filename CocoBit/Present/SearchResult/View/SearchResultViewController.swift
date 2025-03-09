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

final class SearchResultViewController: BaseViewController {
    
    private let searchText: String
    private let searchTextField = {
        let textfield = UITextField()
        textfield.textColor = .cocoBitBlack
        textfield.frame = CGRect(x: 0, y: 0, width: 300, height: 30)
        return textfield
    }()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<TrendingSectionModel> { dataSource, collectionView, indexPath, item in

        switch item {
        case .coin(let item):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
//            cell.configureData(item)

            return cell
            
        case .nft(let item):
            return UICollectionViewCell()
        }
        
    }
                                                                                              
    init(searchText: String) {
        self.searchText = searchText
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        bind()
        
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)

    }
    
    
    
    private func bind() {
        var coinList: [SectionItem] = [SectionItem.coin(model: CoinItem(score: "2", symbol: "3", name: "4", change: "5", changeColor: .down, image: "6")),
                                       SectionItem.coin(model: CoinItem(score: "2", symbol: "3", name: "4", change: "5", changeColor: .down, image: "6")),
                                       SectionItem.coin(model: CoinItem(score: "2", symbol: "3", name: "4", change: "5", changeColor: .down, image: "6")),
                                       SectionItem.coin(model: CoinItem(score: "2", symbol: "3", name: "4", change: "5", changeColor: .down, image: "6"))]
        
        
        let sections = BehaviorSubject<[TrendingSectionModel]>(value: [.coinSection(header: ("인기 검색어", "ss"), data: coinList)])
        
        sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        
    }

}

// MARK: CollectionView Layout
extension SearchResultViewController {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/10))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0) // 아이템 간 간격
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = 20 // 그룹간 간격
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
//        section.orthogonalScrollingBehavior = .groupPaging
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
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
        view.addSubviews(collectionView)
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
