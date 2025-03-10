//
//  DetailViewModel.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/10/25.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailViewModel: BaseViewModel {
    
    var disposeBag = DisposeBag()
    
    struct Input {
//        let moreButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        let detailList = PublishRelay<[DetailSectionModel]>()
        
        
        

        return Output()
    }
}
