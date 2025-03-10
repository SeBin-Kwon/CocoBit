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
    case chart(model: ChartItem)
    case stock(model: StockItem)
    case investment(model: InvestmentItem)
}

enum DetailSectionModel {
    case chartSection(data: [DetailSectionItem])
    case stockSection(header: String, data: [DetailSectionItem])
    case investmentSection(header: String, data: [DetailSectionItem])
}

struct ChartItem {
    let crrentPrice: String
    let change24h: String
}

struct StockItem {
    let title: String
    let value: String
    let date: String
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
        case .investmentSection(let header, _): header
        default: ""
        }
    }
    
    var items: [DetailSectionItem] {
        switch self {
        case .chartSection(let items): items
        case .stockSection(_, let items): items
        case .investmentSection(_, let items): items
        }
    }
    
    init(original: Self, items: [Self.Item]) {
        self = original
    }
}


final class DetailViewController: BaseViewController {
    
    lazy var viewModel = DetailViewModel()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private let titleView = DetailTitleView()
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<DetailSectionModel> (configureCell: { dataSource, collectionView, indexPath, item in
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailStockCollectionViewCell.identifier, for: indexPath) as? DetailStockCollectionViewCell else { return UICollectionViewCell() }
        
        switch item {
        case .chart(let item):
            return UICollectionViewCell()
        case .stock(let item):
            cell.nameLabel.text = item.title
            cell.valueLabel.text = item.value
            cell.dateLabel.text = item.date
//            cell.layer.borderColor = UIColor.red.cgColor
//            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 20
//            cell.configureData(item)
            return cell
            
        case .investment(let item):
            cell.nameLabel.text = item.marketCap
//            cell.backgroundColor = .cocoBitLightGray
            cell.layer.cornerRadius = 20
//            cell.backgroundColor = .gray
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
        configureHierarchy()
        configureLayout()
        configureCollectionView()
        bind()
    }
    
    private func bind() {
        let input = DetailViewModel.Input()
        let output = viewModel.transform(input: input)
        
//        let list = BehaviorRelay<[DetailSectionModel]>(value: [
//            .stockSection(header: "종목정보",
//                          data: [.stock(model: StockItem(high24h: "높은 가격1", row24h: "234")),
//                                 .stock(model: StockItem(high24h: "높은 가격1", row24h: "234")),
//                                 .stock(model: StockItem(high24h: "높은 가격1", row24h: "234")),
//                                 .stock(model: StockItem(high24h: "높은 가격1", row24h: "234"))]
//                         ),
//            .investmentSection(header: "투자지표",
//                        data: [.investment(model: InvestmentItem(marketCap: "시가총액1", valuation: "234")),
//                               .investment(model: InvestmentItem(marketCap: "시가총액1", valuation: "234")),
//                               .investment(model: InvestmentItem(marketCap: "시가총액1", valuation: "234"))])
//        ])
        
        output.detailList
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.titleView
            .drive(with: self) { owner, value in
                owner.titleView.configureData(value)
            }
            .disposed(by: disposeBag)
    }

}


// MARK: CollectionView Layout
extension DetailViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            self?.createSection(index: sectionIndex)
        }
        
        layout.register(DetailSectionBackgroundView.self,
                        forDecorationViewOfKind: DetailSectionBackgroundView.identifier)
        return layout
    }
    
    // 헤더
    func createSection(index: Int) -> NSCollectionLayoutSection {
        let section: NSCollectionLayoutSection
        switch index {
        case 0: section = configureStockSection()
        case 1: section = configureInvestmentSection()
        default: section = configureStockSection()
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
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: DetailSectionBackgroundView.identifier)
        sectionBackgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 45, leading: 20, bottom: 0, trailing: 20)
        section.decorationItems = [sectionBackgroundDecoration]
        return section
    }
    
    // 첫번째 섹션
    private func configureStockSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15) // 아이템 간 간격
        
        let innerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1))
        
        let innerGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerSize, subitems: [item])
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/11))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [innerGroup])
        
        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = 20 // 그룹간 간격
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25)

        return section
    }
    
    // 두번째 섹션
    private func configureInvestmentSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/5))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        //        section.interGroupSpacing = 20 // 그룹간 간격
//                section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
//        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    private func configureCollectionView() {
        collectionView.register(DetailStockCollectionViewCell.self, forCellWithReuseIdentifier: DetailStockCollectionViewCell.identifier)
    
        collectionView.register(
            SearchSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SearchSectionHeaderView.identifier
        )
//        collectionView.backgroundColor = .clear
    }
}

extension DetailViewController {
    private func configureHierarchy() {
        view.addSubviews(collectionView)
        navigationItem.titleView = titleView
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
