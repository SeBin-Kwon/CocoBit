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

class LoadingIndicator {
    static func showLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }

            let loadingIndicatorView: UIActivityIndicatorView
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = UIActivityIndicatorView(style: .large)
                /// 다른 UI가 눌리지 않도록 indicatorView의 크기를 full로 할당
                loadingIndicatorView.frame = window.frame
                loadingIndicatorView.color = .brown
                window.addSubview(loadingIndicatorView)
            }

            loadingIndicatorView.startAnimating()
        }
    }
    
    static func hideLoading() {
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                    guard let window = UIApplication.shared.windows.last else { return }
                    window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
                }
        }
    }
}

final class SearchViewController: BaseViewController {
    
    private let searchView = CocoBitSearchBar()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<TrendingSectionModel> (configureCell: { dataSource, collectionView, indexPath, item in

        switch item {
        case .coin(let item):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
            cell.configureData(item)
            return cell
            
        case .nft(let item):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionViewCell.identifier, for: indexPath) as? NFTCollectionViewCell else { return UICollectionViewCell() }
            cell.configureData(item)
            return cell
        }
        
    }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SearchSectionHeaderView.identifier,
            for: indexPath
        ) as! SearchSectionHeaderView
        let sectionHeader = dataSource.sectionModels[indexPath.section].header
        header.titleLabel.text = sectionHeader.title
        header.timeLabel.text = sectionHeader.time
        return header
    })
    
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureCollectionView()
        bind()
    }
    
    private func bind() {
        
        let input = SearchViewModel.Input(
            searchButtonTap: searchView.searchBar.rx.searchButtonClicked,
            searchText: searchView.searchBar.rx.text,
            coinCellTap: collectionView.rx.modelSelected(TrendingSectionItem.self)
        )
        let output = viewModel.transform(input: input)
        
        SearchState.shared.searchText
            .bind(to: searchView.searchBar.rx.text)
            .disposed(by: disposeBag)
        
        output.searchText
            .drive(with: self) { owner, value in
                if !value.isEmpty {
                    let vc = SearchResultTabViewController()
                    SearchState.shared.searchText.accept(value) // 검색
                    owner.navigate(.push(vc))
                }
                owner.view.endEditing(true)
                
            }
            .disposed(by: disposeBag)
        
        
        output.detailValue
            .drive(with: self) { owner, value in
                let vc = DetailViewController()
                switch value {
                case .coin(let item):
                    vc.viewModel.id.accept(item.id)
                default: break
                }
                owner.view.endEditing(true)
                owner.navigate(.push(vc))
            }
            .disposed(by: disposeBag)
        
        
        output.sectionModel
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.errorAlert
            .drive(with: self) { owner, value in
                let vc = PopUpViewController()
                vc.text = value
                vc.modalPresentationStyle = .overFullScreen
                owner.navigate(.present(vc))
            }
            .disposed(by: disposeBag)
        
        NetworkMonitor.shared.isPopUp
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, value in
                if !value {
                    let vc = PopUpViewController()
                    vc.modalPresentationStyle = .overFullScreen
                    vc.isNetwork = value
                    owner.navigate(.present(vc))
                }
            }
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
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        collectionView.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: NFTCollectionViewCell.identifier)
        collectionView.register(
            SearchSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SearchSectionHeaderView.identifier
        )
        collectionView.isScrollEnabled = false
    }
}


// MARK: View Layout
extension SearchViewController {
    private func configureNavigationBar() {
        let titleView = UIBarButtonItem(customView: NavigationTitleView(title: "가상자산 / 심볼 검색"))
        navigationItem.leftBarButtonItem = titleView
    }
    
    private func configureHierarchy() {
        view.addSubviews(searchView, collectionView)
    }
    
    private func configureLayout() {
        searchView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
