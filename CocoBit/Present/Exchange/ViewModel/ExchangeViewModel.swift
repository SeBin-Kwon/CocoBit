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
    private let errorAlert = PublishRelay<String>()
    
    struct Input {
        let tradeButtonTap: (tap: ControlEvent<Void>, state: BehaviorRelay<Bool?>)
        let changeButtonTap: (tap: ControlEvent<Void>, state: BehaviorRelay<Bool?>)
        let priceButtonTap: (tap: ControlEvent<Void>, state: BehaviorRelay<Bool?>)
    }
    
    struct Output {
        let marketList: Driver<[MarketFormatted]>
        let tradeSorted: Driver<Bool?>
        let changeSorted: Driver<Bool?>
        let priceSorted: Driver<Bool?>
        let errorAlert: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let marketList = PublishRelay<[MarketFormatted]>()
        let tradeSorted = PublishRelay<Bool?>()
        let changeSorted = PublishRelay<Bool?>()
        let priceSorted = PublishRelay<Bool?>()
        
        let currentSortType = BehaviorRelay(value: SortType.price)
        let currentSortState = BehaviorRelay<Bool?>(value: nil)
        
        
        
        let timer = Observable<Int>
            .timer(.microseconds(0), period: .seconds(5), scheduler: MainScheduler.instance)
        
        Observable.combineLatest(timer, currentSortType, NotificationCenterManager.retryAPI.addObserver().startWith(()))
            .debug("api")
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                owner.callRequest()
            }
            .bind(with: self) { owner, value in
                let sortedResult = owner.sortedData(value: value, state: currentSortState.value, type: currentSortType.value)
                
                let result = owner.formattedData(sortedResult.0)
                marketList.accept(result)
            }
            .disposed(by: disposeBag)
        
        input.tradeButtonTap.tap
            .withLatestFrom(timer)
            .bind(with: self) { owner, _ in
                currentSortType.accept(.trade)
                let newState = owner.changeState(input.tradeButtonTap.state.value)
                currentSortState.accept(newState)
                tradeSorted.accept(newState)
                priceSorted.accept(nil)
                changeSorted.accept(nil)
            }
            .disposed(by: disposeBag)

        input.changeButtonTap.tap
            .withLatestFrom(timer)
            .bind(with: self) { owner, _ in
                currentSortType.accept(.change)
                let newState = owner.changeState(input.changeButtonTap.state.value)
                currentSortState.accept(newState)
                changeSorted.accept(newState)
                priceSorted.accept(nil)
                tradeSorted.accept(nil)
            }
            .disposed(by: disposeBag)
        
        input.priceButtonTap.tap
            .withLatestFrom(timer)
            .bind(with: self) { owner, _ in
                currentSortType.accept(.price)
                let newState = owner.changeState(input.priceButtonTap.state.value)
                currentSortState.accept(newState)
                priceSorted.accept(newState)
                tradeSorted.accept(nil)
                changeSorted.accept(nil)
            }
            .disposed(by: disposeBag)

        
        return Output(
            marketList: marketList.asDriver(onErrorJustReturn: []),
            tradeSorted: tradeSorted.asDriver(onErrorJustReturn: nil),
            changeSorted: changeSorted.asDriver(onErrorJustReturn: nil),
            priceSorted: priceSorted.asDriver(onErrorJustReturn: nil),
            errorAlert: errorAlert.asDriver(onErrorJustReturn: "")
        )
    }
    

    private func callRequest() -> Single<[MarketData]> {
        NetworkManager.shared.fetchResults(api: EndPoint.market(currency: .KRW), type: [MarketData].self)
            .catch { [weak self] error in
                let data = [MarketData]()
                guard let error = error as? UpbitError else { return Single.just(data) }
                        self?.errorAlert.accept(error.localizedDescription)
                return Single.just(data)
            }
    }
    
    private func changeState(_ state: Bool?) -> Bool? {
        let newState: Bool?
        switch state {
        case .none:
            newState = false
        case let .some(value):
            let result = value ? nil : true
            newState = result
        }
        return newState
    }
    
    private func sortedData(value: [MarketData], state: Bool?, type: SortType) -> ([MarketData], Bool?) {

        let newList = value.sorted {
            switch type {
            case .trade:
                guard let state else {
                    return $0.accTradePrice24h > $1.accTradePrice24h
                }
                if state {
                    return $0.tradePrice < $1.tradePrice
                } else {
                    return $0.tradePrice > $1.tradePrice
                }
            case .change:
                guard let state else {
                    return $0.accTradePrice24h > $1.accTradePrice24h
                }
                if state {
                    return $0.signedChangeRate < $1.signedChangeRate
                } else {
                    return $0.signedChangeRate > $1.signedChangeRate
                }
            case .price:
                guard let state else {
                    return $0.accTradePrice24h > $1.accTradePrice24h
                }
                if state {
                    return $0.accTradePrice24h < $1.accTradePrice24h
                } else {
                    return $0.accTradePrice24h > $1.accTradePrice24h
                }
            }
        }
        return (newList, state)
    }
    
    private func formattedData(_ data: [MarketData]) -> [MarketFormatted] {
        var result = [MarketFormatted]()
        let formatter = FormatManager.shared
        
        data.forEach { value in
            let rateResult = formatter.roundDecimal(value.signedChangeRate, isArrow: false)
            let priceResult = formatter.roundDecimal(value.signedChangePrice, isArrow: false)
            
            let format = MarketFormatted(
                market: formatter.marketFormatted(value.market),
                tradePrice: formatter.tradeFormatted(value.tradePrice),
                signedChangeRate: (rateResult.str + "%", rateResult.color),
                signedChangePrice: (priceResult.str, priceResult.color),
                accTradePrice24h: formatter.convertToMillions(value.accTradePrice24h))
            result.append(format)
        }
        
        
        return result
    }
    
}

enum SortType {
    case trade
    case change
    case price
}

struct MarketFormatted {
    let market: String
    let tradePrice: String
    let signedChangeRate: (String, DecimalState)
    let signedChangePrice: (String, DecimalState)
    let accTradePrice24h: String
}
