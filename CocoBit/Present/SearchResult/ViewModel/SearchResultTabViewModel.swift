//
//  SearchResultTabViewModel.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/10/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchResultTabViewModel: BaseViewModel {
    
    var disposeBag = DisposeBag()
    
    struct Input {
       
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
//        searchText
//            .debug("searchText")
//            .bind {
//                print($0)
//            }
//            .disposed(by: disposeBag)
        
        return Output()
    }
}
