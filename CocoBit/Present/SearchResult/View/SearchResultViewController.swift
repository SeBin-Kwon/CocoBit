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
//import RxDataSources

final class SearchResultViewController: BaseViewController {
    
//    private let searchText: String
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
//    private let dataSource = RxCollectionViewSectionedReloadDataSource<TrendingSectionModel> { dataSource, collectionView, indexPath, item in
//
//        switch item {
//        case .coin(let item):
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
////            cell.configureData(item)
//
//            return cell
//            
//        case .nft(let item):
//            return UICollectionViewCell()
//        }
//        
//    }
    
    let viewModel = SearchResultViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        bind()
        
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)

    }
    
    
    
    private func bind() {
        let input = SearchResultViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.searchList
            .drive(collectionView.rx.items(cellIdentifier: SearchResultCollectionViewCell.identifier, cellType: SearchResultCollectionViewCell.self)) { item, element, cell in
                cell.configureData(element)
            }
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}


// MARK: View Layout
extension SearchResultViewController {
    private func configureHierarchy() {
        view.addSubviews(collectionView)
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
