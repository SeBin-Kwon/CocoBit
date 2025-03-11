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
import Toast

final class DetailViewController: BaseViewController {
    
    lazy var viewModel = DetailViewModel()
    private let titleView = DetailTitleView()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private let likeButton = LikeButton()
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<DetailSectionModel> (configureCell: { dataSource, collectionView, indexPath, item in
        
        switch item {
        case .chart(let item):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCollectionViewCell.identifier, for: indexPath) as? ChartCollectionViewCell else { return UICollectionViewCell() }
            cell.configureData(item)
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
//        header.moreButton.rx.tap
//            .withUnretained(self)
//            .bind {
//                
//            }
//            .disposed(by: disposeBag)
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
        let name = BehaviorRelay(value: "")
        
        let input = DetailViewModel.Input(
            likeButtonTap: likeButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.detailList
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.titleView
            .drive(with: self) { owner, value in
                owner.titleView.configureData((value.0, value.1))
                name.accept(value.2)
            }
            .disposed(by: disposeBag)
        
        output.likeState
            .drive(with: self) { owner, value in
                owner.likeButton.isSelected = value
            }
            .disposed(by: disposeBag)
        
        output.isButtonTap
            .withLatestFrom(output.likeState)
            .drive(with: self) { owner, value in
                owner.toast(value, name.value)
            }
            .disposed(by: disposeBag)
        
        output.errorAlert
            .drive(with: self) { owner, value in
                let vc = PopUpViewController()
                vc.text = value
                vc.modalPresentationStyle = .overFullScreen
                owner.navigate(.present(vc))
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
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.45))
        
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: likeButton)
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
