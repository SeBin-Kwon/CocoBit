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
    
//    let id: String
//    
//    init(id: String) {
//        self.id = id
//    }
    let id = PublishRelay<String>()
    
    struct Input {
//        let moreButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
//        let id = BehaviorRelay(value: id)
        let detailList = PublishRelay<[DetailSectionModel]>()
        
        id
            .debug("Detail ID")
            .flatMapLatest { id in
                NetworkManager.shared.fetchResults(api: .detail(currency: .KRW, id: id), type: [DetailData].self)
            }
            .subscribe(onNext: { value in
                dump(value)
            }, onError: { error in
                print("Erorr: ", error)
            }, onCompleted: {
                print("onCompleted")
            }, onDisposed: {
                print("onDisposed")
            })
//            .bind { _ in
//                print("DetailDetail")
//            }
            .disposed(by: disposeBag)
        
        

        return Output()
    }
}

//struct Detail: Decodable {
//    let detailArray: [DetailData]
//}


