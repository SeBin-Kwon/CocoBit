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
        let titleView: Driver<(String, String)>
//        let image:
        let name: Driver<String>
    }
    
    func transform(input: Input) -> Output {
//        let id = BehaviorRelay(value: id)
        let detailList = PublishRelay<[DetailSectionModel]>()
        let titleView = PublishRelay<(String, String)>()
//        let image = PublishRelay<String>()
        let name = PublishRelay<String>()
        
        id
            .debug("Detail ID")
            .flatMapLatest { id in
                NetworkManager.shared.fetchResults(api: .detail(currency: .KRW, id: id), type: [DetailData].self)
                    .catch { error in
                        let data = [DetailData]()
        //                        guard let error = error as? APIError else { return Single.just(data) }
        //                        self?.errorAlert.accept([String(error.rawValue), error.title, error.localizedDescription])
                        return Single.just(data)
                    }
            }
            .bind { value in
                guard let value = value.first else { return }
                titleView.accept((value.image, value.symbol))
                name.accept(value.symbol)
//                image.accept(value.image)
//                name.accept(value.symbol)
            }
            .disposed(by: disposeBag)
        
        

        return Output(titleView: titleView.asDriver(onErrorJustReturn: ("","")),
                      name: name.asDriver(onErrorJustReturn: ""))
    }
}

//struct Detail: Decodable {
//    let detailArray: [DetailData]
//}


