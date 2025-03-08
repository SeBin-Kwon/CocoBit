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
import RxDataSources


struct SectionModel {
    var name: String
    var items: [Item]
}

struct CellItem {
    let title: String
}

extension SectionModel: SectionModelType {
    typealias Item = CellItem
    
    init(original: SectionModel, items: [CellItem]) {
        self = original
        self.items = items
    }
}

class SearchSectionHeaderView: UICollectionReusableView {
    static let identifier = "SearchSectionHeaderView"
    let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .boldSystemFont(ofSize: 18)
            label.textColor = .black
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(10)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}


final class SearchViewController: BaseViewController {
    
    private let searchBar = CocoBitSearchBar()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = NavigationTitleView(title: "가상자산 / 심볼 검색")
        
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        collectionView.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: NFTCollectionViewCell.identifier)
        collectionView.register(
            SearchSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SearchSectionHeaderView.identifier
        )
        collectionView.isScrollEnabled = false
        
        configureHierarchy()
        configureLayout()
        bind()
    }
    
    
    private func bind() {
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel> (configureCell: { dataSource, collectionView, indexPath, item in
            //            let section = dataSource[indexPath.section].sectionType
            
            if indexPath.section == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
                cell.backgroundColor = .red
                cell.titleLabel.text = item.title
                
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionViewCell.identifier, for: indexPath) as? NFTCollectionViewCell else { return UICollectionViewCell() }
                cell.backgroundColor = .blue
                cell.titleLabel.text = item.title
                return cell
            }
        }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SearchSectionHeaderView.identifier,
                for: indexPath
            ) as! SearchSectionHeaderView
            header.titleLabel.text = dataSource.sectionModels[indexPath.section].name
            header.backgroundColor = .systemTeal
            return header
        })
        
        let sections = Observable.just([
            SectionModel(name: "search", items: [
                CellItem(title: "Card 1"), CellItem(title: "Card 2"), CellItem(title: "Card 3"),
                CellItem(title: "Card 4"), CellItem(title: "Card 5"), CellItem(title: "Card 6"),
                CellItem(title: "Card 7"), CellItem(title: "Card 8"), CellItem(title: "Card 9"),
                CellItem(title: "Card 10"), CellItem(title: "Card 11"), CellItem(title: "Card 12"),
                CellItem(title: "Card 13"), CellItem(title: "Card 14")
            ]),
            SectionModel(name: "nft", items: [
                CellItem(title: "Row 1"), CellItem(title: "Row 2"), CellItem(title: "Row 3"),
                CellItem(title: "Row 4"), CellItem(title: "Row 5"), CellItem(title: "Row 6"),
                CellItem(title: "Row 7")
            ])
        ])
        
        sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        }

    }
    


extension SearchViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            
            
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/7))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5) // 아이템 간 간격
                
                let innerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1))
                
                let innerGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerSize, subitems: [item])
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [innerGroup])
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10 // 그룹간 간격
//                section.orthogonalScrollingBehavior = .groupPagingCentered
                
                let headerSize = NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .absolute(50)
                        )
                        let header = NSCollectionLayoutBoundarySupplementaryItem(
                            layoutSize: headerSize,
                            elementKind: UICollectionView.elementKindSectionHeader,
                            alignment: .top
                        )
                        
                        section.boundarySupplementaryItems = [header]
                
                return section
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/5), heightDimension: .fractionalHeight(1))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5) // 아이템 간 간격
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.1), heightDimension: .absolute(120))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                //        section.interGroupSpacing = 20 // 그룹간 간격
//                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.orthogonalScrollingBehavior = .continuous
                
                let headerSize = NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .absolute(50)
                        )
                        let header = NSCollectionLayoutBoundarySupplementaryItem(
                            layoutSize: headerSize,
                            elementKind: UICollectionView.elementKindSectionHeader,
                            alignment: .top
                        )
                        
                        section.boundarySupplementaryItems = [header]
                
                return section
            }
        }
        return layout
    }
    
    private func configureHierarchy() {
        view.addSubviews(searchBar, collectionView)
    }
    
    private func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
