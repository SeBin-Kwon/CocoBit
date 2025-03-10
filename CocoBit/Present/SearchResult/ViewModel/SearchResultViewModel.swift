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
        
    }
    
    func transform(input: Input) -> Output {
//        let searchList = PublishRelay<
        
        SearchState.shared.searchText
            .debug("searchText")
            .flatMapLatest { query in
                NetworkManager.shared.fetchResults(api: .searchResult(query: query), type: SearchResult.self)
            }
            .subscribe(onNext: { value in
                dump(value)
            }, onError: { error in
                print("Error", error)
            }, onCompleted: {
                print("onCompleted")
            }, onDisposed: {
                print("onDisposed")
            })
//            .bind {
//                print($0)
//            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}

