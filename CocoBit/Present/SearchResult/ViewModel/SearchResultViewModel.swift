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
        
    }
    
    struct Output {
        let searchList: Driver<[SearchData]>
    }
    
    func transform(input: Input) -> Output {
        let searchList = PublishRelay<[SearchData]>()
        
        SearchState.shared.searchText
            .debug("searchText")
            .flatMapLatest { query in
                NetworkManager.shared.fetchResults(api: .searchResult(query: query), type: SearchResult.self)
                    .catch { error in
                        let data = SearchResult(coins: [SearchData]())
                        //                        guard let error = error as? APIError else { return Single.just(data) }
                        //                        self?.errorAlert.accept([String(error.rawValue), error.title, error.localizedDescription])
                        return Single.just(data)
                    }
            }
            .bind {
                searchList.accept($0.coins)
            }
            .disposed(by: disposeBag)
        
        return Output(searchList: searchList.asDriver(onErrorJustReturn: []))
    }
}

