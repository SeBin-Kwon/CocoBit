//
//  DetailSectionHeaderView.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/11/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Toast

final class DetailSectionHeaderView: UICollectionReusableView {
    static var identifier: String {
        String(describing: self)
    }
    
    private let disposeBag = DisposeBag()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .setFont(.subTitle)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let moreButton = MoreButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        bind()
    }
    
    private func bind() {
        moreButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.makeToast("준비 중입니다", position: .bottom)
        }
        .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        addSubviews(titleLabel, moreButton)
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview()
        }
    }
}
