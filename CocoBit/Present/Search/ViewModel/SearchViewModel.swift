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
        let sectionModel: Driver<[TrendingSectionModel]>
    }
    
    func transform(input: Input) -> Output {
        let sectionModel = PublishRelay<[TrendingSectionModel]>()
        
        Observable<Int>
            .timer(.microseconds(0), scheduler: MainScheduler.instance)
            .debug("TRENDING")
            .flatMapLatest { _ in
                NetworkManager.shared.fetchResults(api: EndPoint.trending, type: Trending.self)
                    .catch { error in
                        let data = Trending(coins: [TrendingCoin](), nfts: [TrendingNFTItem]())
        //                        guard let error = error as? APIError else { return Single.just(data) }
        //                        self?.errorAlert.accept([String(error.rawValue), error.title, error.localizedDescription])
                        return Single.just(data)
                    }
            }
            .bind(with: self) { owner, value in
                let result = owner.convertToSectionModel(value)
                sectionModel.accept(result)
            }
            .disposed(by: disposeBag)
        
        return Output(sectionModel: sectionModel.asDriver(onErrorJustReturn: []))
    }
    
    private func convertToSectionModel(_ data: Trending) -> [TrendingSectionModel] {
        let formatter = FormatManager.shared
        
        var coinList = [SectionItem]()
        var nftList = [SectionItem]()
        let coinHeader = ("인기 검색어", formatter.trendingDateFormatted())
        let nftHeader = "인기 NFT"
        
        data.coins.forEach {
            let changeResult = formatter.roundDecimal($0.item.data.change.krw, isArrow: true)
            coinList.append(
                .coin(model: CoinItem(
                    score: "\($0.item.score + 1)",
                    symbol: $0.item.symbol,
                    name: $0.item.name,
                    change: changeResult.str + "%",
                    changeColor: changeResult.color,
                    image: $0.item.thumb)
                )
            )
        }
        coinList.removeLast()
        
        data.nfts.forEach {
            let changeResult = formatter.roundDecimal($0.change, isArrow: true)
            nftList.append(
                .nft(model: NFTItem(
                    name: $0.name,
                    price: $0.data.price,
                    change: changeResult.str + "%",
                    changeColor: changeResult.color,
                    image: $0.thumb)
                )
            )
        }
        
        return [.coinSection(header: coinHeader, data: coinList),
                .nftSection(header: nftHeader, data: nftList)]
    }
    
    
}
