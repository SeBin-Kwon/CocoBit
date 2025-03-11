//
//  SearchResultCellViewModel.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/11/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchResultCellViewModel: BaseViewModel {
    
    var disposeBag = DisposeBag()
    var item: SearchData?
    
    struct Input {
        let likeButtonTap: ControlEvent<Void>
        let likeState: Binder<Bool>
    }
    
    struct Output {
        let likeState: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let likeState = BehaviorRelay(value: false)
        
        input.likeButtonTap
            .withLatestFrom(likeState)
            .bind(with: self) { owner, state in
                likeState.accept(!state)
                guard let item = owner.item else { return }
                switch !state {
                case true:
                    let data = FavoriteTable(id: item.id, name: item.name, symbol: item.symbol, image: item.thumb)
                    RealmManager.add(data)
                case false:
                    guard let likeItem = RealmManager.findData(FavoriteTable.self, key: item.id) else { return }
                    RealmManager.delete(likeItem)
                }
            }
            .disposed(by: disposeBag)
        
        RealmManager.$favoriteTable
            .bind(with: self) { owner, value in
                guard let item = owner.item else { return }
                if let item = RealmManager.findData(FavoriteTable.self, key: item.id) {
                    likeState.accept(true)
                } else {
                    likeState.accept(false)
                }
            }
            .disposed(by: disposeBag)

        return Output(likeState: likeState.asDriver())
    }
}

