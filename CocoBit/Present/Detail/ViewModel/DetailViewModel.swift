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
    let id = PublishRelay<String>()
    
    struct Input {
        let likeButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let titleView: Driver<(String, String,String)>
        let detailList: Driver<[DetailSectionModel]>
        let likeState: Driver<Bool>
        let isButtonTap: Driver<Bool>
        let errorAlert: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let detailList = PublishRelay<[DetailSectionModel]>()
        let detailItem = BehaviorRelay<DetailData?>(value: nil)
        let titleView = PublishRelay<(String, String,String)>()
        let state = BehaviorRelay(value: false)
        let isButtonTap = BehaviorRelay(value: false)
        let errorAlert = PublishRelay<String>()
        
        id
            .debug("Detail ID")
            .flatMapLatest { id in
                NetworkManager.shared.fetchResults(api: .detail(currency: .KRW, id: id), type: [DetailData].self)
                    .catch { error in
                        let data = [DetailData]()
                        guard let error = error as? APIError else { return Single.just(data) }
                        errorAlert.accept( error.localizedDescription)
                        return Single.just(data)
                    }
            }
            .bind(with: self) { owner, value in
                guard let value = value.first else { return }
                let symbol = value.symbol.uppercased()
                titleView.accept((value.image, symbol, value.name))
                let result = owner.convertToSectionModel(value)
                detailList.accept(result)
                if RealmManager.findData(FavoriteTable.self, key: value.id) != nil {
                    state.accept(true)
                }
                detailItem.accept(value)
            }
            .disposed(by: disposeBag)
        
        input.likeButtonTap
            .withLatestFrom(state)
            .bind(with: self) { owner, value in
                state.accept(!value)
                guard let item = detailItem.value else { return }
                switch !value {
                case true:
                    let data = FavoriteTable(id: item.id, name: item.name, symbol: item.symbol, image: item.image)
                    RealmManager.add(data)
                case false:
                    guard let likeItem = RealmManager.findData(FavoriteTable.self, key: item.id) else { return }
                    RealmManager.delete(likeItem)
                }
                isButtonTap.accept(true)
            }
            .disposed(by: disposeBag)
        
        
        return Output(titleView: titleView.asDriver(onErrorJustReturn: ("","","")),
                      detailList: detailList.asDriver(onErrorJustReturn: []),
                      likeState: state.asDriver(),
                      isButtonTap: isButtonTap.asDriver(),
                      errorAlert: errorAlert.asDriver(onErrorJustReturn: ""))
    }
    
    private func convertToSectionModel(_ data: DetailData) -> [DetailSectionModel] {
        let formatter = FormatManager.shared
        
        var chartList = [DetailSectionItem]()
        var stockList = [DetailSectionItem]()
        var investmentList = [DetailSectionItem]()
        let stockHeader = "종목정보"
        let investmentHeader = "투자지표"
        let changeResult = formatter.roundDecimal(data.change24h, isArrow: true)
        
        stockList.append(contentsOf:
                            [.stock(model:
                                        StockItem(title: "24시간 고가", value: formatter.detailPriceFormatted(data.high24h), date: "")),
                             .stock(model:
                                        StockItem(title: "24시간 저가", value: formatter.detailPriceFormatted(data.low24h), date: "")),
                             .stock(model:
                                        StockItem(title: "역대 최고가", value: formatter.detailPriceFormatted(data.ath), date: formatter.detailDateFormatted(data.athDate))),
                             .stock(model:
                                        StockItem(title: "역대 최저가", value: formatter.detailPriceFormatted(data.atl), date: formatter.detailDateFormatted(data.atlDate)))
                            ])
        
        investmentList.append(contentsOf:
                                [.investment(model:
                                                InvestmentItem(title: "시가총액", value: formatter.detailPriceFormatted(data.marketCap))),
                                 .investment(model:
                                                InvestmentItem(title: "완전 희석 가치(FDV)", value: formatter.detailPriceFormatted(data.fullyValuation))),
                                 .investment(model:
                                                InvestmentItem(title: "총 거래량", value: formatter.detailPriceFormatted(data.totalVolum)))
                                ])
        chartList.append(contentsOf:
                            [.chart(model:
                                        ChartItem(
                                            crrentPrice: formatter.detailPriceFormatted(data.crrentPrice),
                                            change24h: changeResult.str + "%",
                                            changeColor: changeResult.color,
                                            lastUpdated: formatter.detailUpdateFormatted(data.lastUpdated),
                                            chartArray: data.sparklineIn7d.price))])
        
        return [.chartSection(data: chartList),
                .stockSection(header: stockHeader, data: stockList),
                .investmentSection(header: investmentHeader, data: investmentList)]
        
    }
    
}

