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
import Toast

final class SearchResultViewController: BaseViewController {
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private let noResultLable = {
        let label = UILabel()
        label.text = "검색 결과가 없습니다."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .cocoBitGray
        label.isHidden = true
        return label
    }()
    
    let viewModel = SearchResultViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        bind()
        
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
    }
    
    private func bind() {
        let input = SearchResultViewModel.Input(
            cellTap: collectionView.rx.modelSelected(SearchData.self)
        )
        let output = viewModel.transform(input: input)
        
        output.searchList
            .drive(collectionView.rx.items(cellIdentifier: SearchResultCollectionViewCell.identifier, cellType: SearchResultCollectionViewCell.self)) { item, element, cell in
                cell.configureData(element)
                cell.item = element
                
                cell.likeButton.rx.tap
                    .bind(with: self) { owner, state in
                        cell.likeButton.isSelected.toggle()
                        let item = element
                        switch cell.likeButton.isSelected {
                        case true:
                            let data = FavoriteTable(id: item.id, name: item.name, symbol: item.symbol, image: item.thumb)
                            RealmManager.add(data)
                        case false:
                            guard let likeItem = RealmManager.findData(FavoriteTable.self, key: item.id) else { return }
                            RealmManager.delete(likeItem)
                        }
                        owner.toast(cell.likeButton.isSelected, item.name)
                    }
                    .disposed(by: cell.disposeBag)
                
                RealmManager.$favoriteTable
                    .bind(with: self) { owner, value in
                        let item = element
                        if let _ = RealmManager.findData(FavoriteTable.self, key: item.id) {
                            cell.likeButton.isSelected = true
                        } else {
                            cell.likeButton.isSelected = false
                        }
                    }
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        output.detailValue
            .drive(with: self) { owner, value in
                let vc = DetailViewController()
                vc.viewModel.id.accept(value.id)
                owner.view.endEditing(true)
                owner.navigate(.push(vc))
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
        
        output.isNoResult
            .drive(noResultLable.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
}

// MARK: CollectionView Layout
extension SearchResultViewController {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(70))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        
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
        view.addSubviews(collectionView, noResultLable)
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        noResultLable.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
