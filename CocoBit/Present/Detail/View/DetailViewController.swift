//
//  DetailViewController.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/9/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

enum DetailSectionItem {
    case stock(model: StockItem)
    case investment(model: InvestmentItem)
}

enum DetailSectionModel {
    case stockSection(header: String, data: [DetailSectionItem])
    case investment(header: String, data: [DetailSectionItem])
}

struct StockItem {
    let high24h: String
    let row24h: String
}

struct InvestmentItem {
    let marketCap: String
    let valuation: String
}

extension DetailSectionModel: SectionModelType {
    typealias Item = DetailSectionItem
    
    var header: String {
        switch self {
        case .stockSection(let header, _): header
        case .investment(let header, _): header
        }
    }
    
    var items: [DetailSectionItem] {
        switch self {
        case .stockSection(_, let items): items
        case .investment(_, let items): items
        }
    }
    
    init(original: Self, items: [Self.Item]) {
        self = original
    }
}


final class DetailViewController: BaseViewController {
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<DetailSectionModel> (configureCell: { dataSource, collectionView, indexPath, item in
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.identifier, for: indexPath) as? DetailCollectionViewCell else { return UICollectionViewCell() }
        
        switch item {
        case .stock(let item):
            cell.nameLabel.text = item.high24h
            cell.backgroundColor = .cocoBitLightGray
//            cell.configureData(item)
            return cell
            
        case .investment(let item):
            cell.nameLabel.text = item.marketCap
            cell.backgroundColor = .lightGray
//            cell.configureData(item)
            return cell
        }
        
    }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SearchSectionHeaderView.identifier,
            for: indexPath
        ) as! SearchSectionHeaderView
        let sectionHeader = dataSource.sectionModels[indexPath.section].header
        header.titleLabel.text = sectionHeader
        return header
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "detail"
        configureHierarchy()
        configureLayout()
        configureCollectionView()
        bind()
    }
    
    private func bind() {
        let list = BehaviorRelay<[DetailSectionModel]>(value: [
            .stockSection(header: "종목정보",
                          data: [.stock(model: StockItem(high24h: "높은 가격", row24h: "낮은 가격")),
                                .stock(model: StockItem(high24h: "높은 가격", row24h: "낮은 가격")),
                                 .stock(model: StockItem(high24h: "높은 가격", row24h: "낮은 가격"))]
                         ),
            .investment(header: "투자지표",
                        data: [.investment(model: InvestmentItem(marketCap: "시가총액", valuation: "가치")),
                            .investment(model: InvestmentItem(marketCap: "시가총액", valuation: "가치")),
                            .investment(model: InvestmentItem(marketCap: "시가총액", valuation: "가치"))])
        ])
        
        list
            .bind(to:collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

}


// MARK: CollectionView Layout
extension DetailViewController {
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
                    heightDimension: .absolute(45)
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
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15) // 아이템 간 간격
        
        let innerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1))
        
        let innerGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerSize, subitems: [item])
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.55))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [innerGroup])
        
        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = 20 // 그룹간 간격
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        return section
    }
    
    // 두번째 섹션
    private func configureSectionTwo() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/5), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3) // 아이템 간 간격
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.1), heightDimension: .absolute(125))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        //        section.interGroupSpacing = 20 // 그룹간 간격
//                section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    private func configureCollectionView() {
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.identifier)
    
        collectionView.register(
            SearchSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SearchSectionHeaderView.identifier
        )
    }
}

extension DetailViewController {
    private func configureHierarchy() {
        view.addSubviews(collectionView)
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
