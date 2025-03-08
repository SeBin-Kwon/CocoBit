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
        let tradeButtonState: BehaviorRelay<Bool?>
    }
    
    struct Output {
        let tradeSorted: Driver<Bool?>
        let marketList: Driver<[MarketFormatted]>
    }
    
    func transform(input: Input) -> Output {
        let marketList = PublishSubject<[MarketFormatted]>()
        let tradeSorted = PublishRelay<Bool?>()
        
        Observable<Int>
            .timer(.microseconds(0), scheduler: MainScheduler.instance)
//            .timer(.microseconds(0), period: .seconds(5), scheduler: MainScheduler.instance)
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
        
        input.tradeButtonTap
            .debug("BUTTON")
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.callRequest()
            }
            .bind(with: self) { owner, value in
                let sortedResult = owner.sortedData(value: value, state: input.tradeButtonState.value, type: .trade)
                tradeSorted.accept(sortedResult.1)
                let result = owner.formattedData(sortedResult.0)
                marketList.onNext(result)
            }
            .disposed(by: disposeBag)

        
        
        return Output(
            tradeSorted: tradeSorted.asDriver(onErrorJustReturn: nil),
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
    
    private func sortedData(value: [MarketData], state: Bool?, type: SortType) -> ([MarketData], Bool?) {
        
        let newState: Bool?
        switch state {
        case .none:
            newState = false
        case let .some(value):
            let result = value ? nil : true
            newState = result
        }
        
        let newList = value.sorted {
            switch type {
            case .trade:
                guard let newState else {
                    return $0.accTradePrice24h > $1.accTradePrice24h
                }
                if newState {
                    return $0.tradePrice < $1.tradePrice
                } else {
                    return $0.tradePrice > $1.tradePrice
                }
            case .change:
                guard let newState else {
                    return $0.accTradePrice24h > $1.accTradePrice24h
                }
                if newState {
                    return $0.signedChangeRate < $1.signedChangeRate
                } else {
                    return $0.signedChangeRate > $1.signedChangeRate
                }
            case .price:
                guard let newState else {
                    return $0.accTradePrice24h > $1.accTradePrice24h
                }
                if newState {
                    return $0.accTradePrice24h < $1.accTradePrice24h
                } else {
                    return $0.accTradePrice24h > $1.accTradePrice24h
                }
            }
        }
        return (newList, newState)
    }
    
    private func formattedData(_ data: [MarketData]) -> [MarketFormatted] {
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

enum SortType {
    case trade
    case change
    case price
}
