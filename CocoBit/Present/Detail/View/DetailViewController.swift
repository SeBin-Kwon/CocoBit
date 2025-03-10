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
    let lastUpdated: String
    let chartArray: [Double]
}

struct StockItem {
    let title: String
    let value: String
    let date: String
}

struct InvestmentItem {
    let title: String
    let value: String
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
        
        switch item {
        case .chart(let item):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCollectionViewCell.identifier, for: indexPath) as? ChartCollectionViewCell else { return UICollectionViewCell() }
            cell.priceLabel.text = item.crrentPrice
            cell.changeLabel.text = item.change24h
            cell.updateLabel.text = item.lastUpdated
            cell.priceData = item.chartArray
            cell.backgroundColor = .cocoBitLightGray
            return cell
            
        case .stock(let item):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.identifier, for: indexPath) as? DetailCollectionViewCell else { return UICollectionViewCell() }
            cell.nameLabel.text = item.title
            cell.valueLabel.text = item.value
            cell.dateLabel.text = item.date
            cell.layer.cornerRadius = 20
//            cell.configureData(item)
            return cell
            
        case .investment(let item):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.identifier, for: indexPath) as? DetailCollectionViewCell else { return UICollectionViewCell() }
            cell.nameLabel.text = item.title
            cell.valueLabel.text = item.value
//            cell.backgroundColor = .cocoBitLightGray
            cell.layer.cornerRadius = 20
            return cell
        }
        
    }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: DetailSectionHeaderView.identifier,
            for: indexPath
        ) as! DetailSectionHeaderView
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
        case 0: section = configureChartSection()
        case 1: section = configureStockSection()
        case 2: section = configureInvestmentSection()
        default: section = configureStockSection()
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
        if index != 0 {
            section.boundarySupplementaryItems = [header]
            let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: DetailSectionBackgroundView.identifier)
            sectionBackgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 20, bottom: 0, trailing: 20)
            section.decorationItems = [sectionBackgroundDecoration]
        }
        return section
    }
    
    private func configureChartSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/4))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        //        section.interGroupSpacing = 20 // 그룹간 간격
//                section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25)
//        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }

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
    
    private func configureInvestmentSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/6))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        //        section.interGroupSpacing = 20 // 그룹간 간격
//                section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25)
//        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    private func configureCollectionView() {
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.identifier)
        collectionView.register(ChartCollectionViewCell.self, forCellWithReuseIdentifier: ChartCollectionViewCell.identifier)
    
        collectionView.register(
            DetailSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DetailSectionHeaderView.identifier
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
