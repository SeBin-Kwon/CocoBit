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

enum SectionItem {
    case coin(model: CoinItem)
    case nft(model: NFTItem)
}

enum TrendingSectionModel {
    case coinSection(header: String, data: [SectionItem])
    case nftSection(header: String, data: [SectionItem])
}

struct CoinItem {
    let title: String
    let symbol: String
    let change: String
}

struct NFTItem {
    let title: String
    let symbol: String
    let change: String
}

extension TrendingSectionModel: SectionModelType {
    typealias Item = SectionItem
    
    var header: String {
        switch self {
        case .coinSection(let header, _): header
        case .nftSection(let header, _): header
        }
    }
    
    var items: [SectionItem] {
        switch self {
        case .coinSection(_, let items): items
        case .nftSection(_, let items): items
        }
    }
    
    init(original: Self, items: [Self.Item]) {
        self = original
    }
}


class SearchSectionHeaderView: UICollectionReusableView {
    static let identifier = "SearchSectionHeaderView"
    let titleLabel: UILabel = {
            let label = UILabel()
        label.font = .setFont(.subTitle)
        label.textColor = .cocoBitBlack
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
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<TrendingSectionModel> (configureCell: { dataSource, collectionView, indexPath, item in
 
            switch item {
            case .coin(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
                cell.backgroundColor = .systemGray6
                cell.titleLabel.text = item.title
                return cell
                
            case .nft(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionViewCell.identifier, for: indexPath) as? NFTCollectionViewCell else { return UICollectionViewCell() }
                cell.backgroundColor = .systemGray5
                cell.titleLabel.text = item.title
                return cell
            }
            
        }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SearchSectionHeaderView.identifier,
                for: indexPath
            ) as! SearchSectionHeaderView
            header.titleLabel.text = dataSource.sectionModels[indexPath.section].header
            return header
        })
        
        var coinList = [SectionItem]()
        var nftList = [SectionItem]()
        
        mockTrendingCoins.forEach {
            coinList.append(.coin(model: CoinItem(title: $0.item.name, symbol: $0.item.symbol, change: String($0.item.priceBtc))))
        }
        coinList.popLast()
        
        mockTrendingNFTs.forEach {
            nftList.append(.nft(model: NFTItem(title: $0.name, symbol: $0.symbol, change: $0.data.floorPriceInUsd24hPercentageChange)))
        }
        
        let sections = BehaviorSubject<[TrendingSectionModel]>(value: [.coinSection(header: "인기 검색어", data: coinList), .nftSection(header: "인기 NFT", data: nftList)])
        
        sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        }

    }
    

// MARK: CollectionView Layout
extension SearchViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            self?.createSection(index: sectionIndex)
        }
        return layout
    }
    
    // 헤더
    func createSection(index: Int) -> NSCollectionLayoutSection {
        let section: NSCollectionLayoutSection
        switch index {
        case 0: section = configureSectionOne()
        case 1: section = configureSectionTwo()
        default: section = configureSectionOne()
        }
        
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
    
    // 첫번째 섹션
    private func configureSectionOne() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/7))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10) // 아이템 간 간격
        
        let innerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1))
        
        let innerGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerSize, subitems: [item])
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.6))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [innerGroup])
        
        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = 20 // 그룹간 간격
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        return section
    }
    
    // 두번째 섹션
    private func configureSectionTwo() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/5), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5) // 아이템 간 간격
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.1), heightDimension: .absolute(120))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        //        section.interGroupSpacing = 20 // 그룹간 간격
//                section.orthogonalScrollingBehavior = .groupPagingCentered
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
}


// MARK: View Layout
extension SearchViewController {
    private func configureHierarchy() {
        view.addSubviews(searchBar, collectionView)
    }
    
    private func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
