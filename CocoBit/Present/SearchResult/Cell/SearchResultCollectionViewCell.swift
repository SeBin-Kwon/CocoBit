//
//  SearchResultCollectionViewCell.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/9/25.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class SearchResultCollectionViewCell: BaseCollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    let imageView = {
        let image = UIImageView()
        image.backgroundColor = .cocoBitLightGray
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let symbolLabel = {
        let label = UILabel()
        label.text = "sdf"
        label.font = .setFont(.subTitle)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let nameLabel = {
        let label = UILabel()
        label.text = "sdf39239238492837"
        label.font = .setFont(.medium)
        label.textColor = .cocoBitGray
        return label
    }()
    
    let rankLabel = {
        let label = UILabel()
        label.text = "372333"
        label.font = .setFont(.smallBold)
        label.textColor = .cocoBitGray
        return label
    }()
    
    let scoreBackgroundView = {
        let view = UIView()
        view.backgroundColor = .cocoBitLightGray
        view.layer.cornerRadius = 3
        return view
    }()
    
    let likeButton = LikeButton()
    
    var item: SearchData?
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        guard let item else { return }
        likeButton.isSelected = false
        disposeBag = DisposeBag()
        
    }
    
//    private func bind(_ item: SearchData) {
//        let input = SearchResultCellViewModel.Input(
//            likeButtonTap: likeButton.rx.tap,
//            likeState: likeButton.rx.isSelected
//        )
//        let output = viewModel.transform(input: input)
//        
//        output.likeState
//            .drive(likeButton.rx.isSelected)
//            .disposed(by: disposeBag)
        
//        likeButton.rx.tap
//            .bind(with: self) { owner, state in
//                owner.likeButton.isSelected.toggle()
//                guard let item = owner.item else { return }
//                switch owner.likeButton.isSelected {
//                case true:
//                    let data = FavoriteTable(id: item.id, name: item.name, symbol: item.symbol, image: item.thumb)
//                    RealmManager.add(data)
//                case false:
//                    guard let likeItem = RealmManager.findData(FavoriteTable.self, key: item.id) else { return }
//                    RealmManager.delete(likeItem)
//                }
//            }
//            .disposed(by: disposeBag)
        
//        RealmManager.$favoriteTable
//            .bind(with: self) { owner, value in
//                guard let item = owner.item else { return }
//                if let _ = RealmManager.findData(FavoriteTable.self, key: item.id) {
//                    owner.likeButton.isSelected = true
//                } else {
//                    owner.likeButton.isSelected = false
//                }
//            }
//            .disposed(by: disposeBag)
        
            
//    }
    
    func configureData(_ item: SearchData) {
        symbolLabel.text = item.symbol
        nameLabel.text = item.name
        
        let url = URL(string: item.thumb)
        imageView.kf.setImage(with: url)
        
        guard let rank = item.rank else { return }
        rankLabel.text = "\(rank)"
//        bind(item)
    }
    
    override func configureHierarchy() {
        addSubviews(imageView, symbolLabel, nameLabel, scoreBackgroundView, rankLabel, likeButton)
    }
    
    override func configureLayout() {
        
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(36)
        }
        
        symbolLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualToSuperview().inset(45)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(45)
        }
        
        scoreBackgroundView.snp.makeConstraints { make in
            make.width.equalTo(rankLabel).offset(6)
            make.height.equalTo(rankLabel).offset(4)
            make.leading.equalTo(symbolLabel.snp.trailing).offset(5)
            make.centerY.equalTo(symbolLabel)
        }
        
        rankLabel.snp.makeConstraints { make in
            make.center.equalTo(scoreBackgroundView)
        }
        
        likeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }
        
        DispatchQueue.main.async {
            self.imageView.layer.cornerRadius = self.imageView.frame.height / 2
        }
    }
}
