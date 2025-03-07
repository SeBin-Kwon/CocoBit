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
        let marketList: Driver<[MarketFormatted]>
    }
    
    func transform(input: Input) -> Output {
        let marketList = PublishSubject<[MarketFormatted]>()
        
        Observable<Int>
            .timer(.microseconds(0), scheduler: MainScheduler.instance)
            .debug("TIMER")
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.callRequest()
            }
            .bind(with: self) { owner, value in
                let result = owner.formattedData(value)
                marketList.onNext(result)
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
    
    private func formattedData(_ data: PrimitiveSequence<SingleTrait, [MarketData]>.Element) -> [MarketFormatted] {
        var result = [MarketFormatted]()
        let formatter = FormatManager.shared
        
        data.forEach { value in
            let stringRate = formatter.roundDecimal(value.signedChangeRate).0
            let colorRate = formatter.roundDecimal(value.signedChangeRate).1
            let stringPrice = formatter.roundDecimal(value.signedChangePrice).0
            let colorPrice = formatter.roundDecimal(value.signedChangePrice).1
            
            let format = MarketFormatted(
                market: formatter.marketFormatted(value.market),
                tradePrice: formatter.tradeFormatted(value.tradePrice),
                signedChangeRate: (stringRate + "%", colorRate),
                signedChangePrice: (stringPrice, colorPrice),
                accTradePrice24h: formatter.convertToMillions(value.accTradePrice24h))
            result.append(format)
        }
        
        
        return result
    }
    
    struct MarketFormatted {
        let market: String
        let tradePrice: String
        let signedChangeRate: (String, DecimalState)
        let signedChangePrice: (String, DecimalState)
        let accTradePrice24h: String
    }
}
