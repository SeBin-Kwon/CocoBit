//
//  ExchangeViewModel.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/6/25.
//

import Foundation
import RxSwift
import RxCocoa

final class ExchangeViewModel: BaseViewModel {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let tradeButtonTap: ControlEvent<Void>
    }
    
    struct Output {
//        let tradeSorted: Driver<Void>
        let marketList: Driver<[MarketData]>
    }
    
    func transform(input: Input) -> Output {
        let marketList = PublishSubject<[MarketData]>()
        
        Observable<Int>
            .timer(.microseconds(0), period: .seconds(5), scheduler: MainScheduler.instance)
            .debug("TIMER")
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.callRequest()
            }
            .bind { value in
                marketList.onNext(value)
            }
            .disposed(by: disposeBag)

        
        
        return Output(
//            tradeSorted: input.tradeButtonTap.asDriver(),
            marketList: marketList.asDriver(onErrorJustReturn: [])
        )
    }
    
    private func callRequest() -> Single<[MarketData]> {
        NetworkManager.shared.fetchResults(api: EndPoint.market(currency: .KRW), type: [MarketData].self)
            .catch { error in
                let data = [MarketData]()
//                        guard let error = error as? APIError else { return Single.just(data) }
//                        self?.errorAlert.accept([String(error.rawValue), error.title, error.localizedDescription])
                return Single.just(data)
            }
    }
    
    
}
