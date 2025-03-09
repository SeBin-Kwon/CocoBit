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
    let searchText = BehaviorRelay(value: "")
    
    struct Input {
       
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        searchText
            .debug("searchText")
            .bind {
                print($0)
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}
