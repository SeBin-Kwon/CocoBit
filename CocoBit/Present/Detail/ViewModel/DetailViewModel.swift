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
//        let moreButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let titleView: Driver<(String, String)>
        let detailList: Driver<[DetailSectionModel]>
    }
    
    func transform(input: Input) -> Output {
        let detailList = PublishRelay<[DetailSectionModel]>()
        let titleView = PublishRelay<(String, String)>()
        
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
            .bind(with: self) { owner, value in
                guard let value = value.first else { return }
                titleView.accept((value.image, value.symbol))
                let result = owner.convertToSectionModel(value)
                detailList.accept(result)
            }
            .disposed(by: disposeBag)

        return Output(titleView: titleView.asDriver(onErrorJustReturn: ("","")),
                      detailList: detailList.asDriver(onErrorJustReturn: []))
    }
    
    private func convertToSectionModel(_ data: DetailData) -> [DetailSectionModel] {
        let formatter = FormatManager.shared
        
        var stockList = [DetailSectionItem]()
        var investmentList = [DetailSectionItem]()
        let stockHeader = "종목정보"
        let investmentHeader = "투자지표"
        
        stockList.append(contentsOf:
            [.stock(model:
                        StockItem(title: "24시간 고가", value: String(data.high24h), date: "")),
             .stock(model:
                        StockItem(title: "24시간 저가", value: String(data.low24h), date: "")),
             .stock(model:
                        StockItem(title: "역대 최고가", value: String(data.ath), date: data.athDate)),
             .stock(model:
                     StockItem(title: "역대 최저가", value: String(data.atl), date: data.atlDate))
            ])
        return [.stockSection(header: stockHeader, data: stockList)]
        
    }
    
}

//struct Detail: Decodable {
//    let detailArray: [DetailData]
//}


