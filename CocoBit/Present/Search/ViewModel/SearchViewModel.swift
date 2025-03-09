//
//  SearchViewModel.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/9/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: BaseViewModel {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        let coinList = PublishRelay<[SectionItem]>()
        let nftList = PublishRelay<[SectionItem]>()
        
        Observable<Int>
            .timer(.microseconds(0), scheduler: MainScheduler.instance)
            .debug("TRENDING")
            .flatMapLatest { _ in
                NetworkManager.shared.fetchResults(api: EndPoint.trending, type: Trending.self)
//                    .catch { error in
//                        let data = [MarketData]()
        //                        guard let error = error as? APIError else { return Single.just(data) }
        //                        self?.errorAlert.accept([String(error.rawValue), error.title, error.localizedDescription])
//                        return Single.just(data)
//                    }
            }
            .subscribe(onNext: { value in
                print("oonNext>>>", value)
            }, onError: { error in
                print("onError>>>", error)
            }, onCompleted: {
                print("onCompleted")
            }, onDisposed: {
                print("onDisposed")
            })
//            .bind(with: self) { owner, value in
//            }
            .disposed(by: disposeBag)
        
    
        
        return Output()
    }
    
    
}
