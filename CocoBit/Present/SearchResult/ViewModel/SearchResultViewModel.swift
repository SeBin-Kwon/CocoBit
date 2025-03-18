//
//  SearchResultViewModel.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/9/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchResultViewModel: BaseViewModel {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let cellTap: ControlEvent<SearchData>
    }
    
    struct Output {
        let searchList: Driver<[SearchData]>
        let detailValue: Driver<SearchData>
        let errorAlert: Driver<String>
        let isNoResult: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let searchList = PublishRelay<[SearchData]>()
        let detailValue = PublishRelay<SearchData>()
        let errorAlert = PublishRelay<String>()
        let isNoResult = PublishRelay<Bool>()
        
        Observable.combineLatest(SearchState.shared.searchText, NotificationCenterManager.retryAPI.addObserver().startWith(()))
            .flatMapLatest { query, _ in
                NetworkManager.shared.fetchResults(api: .searchResult(query: query), type: SearchResult.self)
                    .catch { error in
                        let data = SearchResult(coins: [SearchData]())
                        guard let error = error as? CoinGeckoError else { return Single.just(data) }
                        errorAlert.accept(error.localizedDescription)
                        return Single.just(data)
                    }
            }
            .bind {
                searchList.accept($0.coins)
                isNoResult.accept($0.coins.isEmpty ? false : true)
            }
            .disposed(by: disposeBag)
        
        input.cellTap
            .bind {
                LoadingIndicator.showLoading()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    LoadingIndicator.hideLoading()
                }
                detailValue.accept($0)
            }
            .disposed(by: disposeBag)
        
        return Output(searchList: searchList.asDriver(onErrorJustReturn: []),
                      detailValue: input.cellTap.asDriver(),
                      errorAlert: errorAlert.asDriver(onErrorJustReturn: ""),
                      isNoResult: isNoResult.asDriver(onErrorJustReturn: true))
    }
}

