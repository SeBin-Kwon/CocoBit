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
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String?>
        let coinCellTap: ControlEvent<TrendingSectionItem>
    }
    
    struct Output {
        let sectionModel: Driver<[TrendingSectionModel]>
        let searchText: Driver<String>
        let detailValue: Driver<TrendingSectionItem>
        let errorAlert: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let sectionModel = PublishRelay<[TrendingSectionModel]>()
        let searchText = PublishRelay<String>()
        let detailValue = PublishRelay<TrendingSectionItem>()
        let errorAlert = PublishRelay<String>()
        
        Observable<Int>
            .timer(.microseconds(0), period: .seconds(600), scheduler: MainScheduler.instance)
            .flatMapLatest { _ in
                NetworkManager.shared.fetchResults(api: EndPoint.trending, type: Trending.self)
                    .catch { error in
                        let data = Trending(coins: [TrendingCoin](), nfts: [TrendingNFTItem]())
                            guard let error = error as? APIError else { return Single.just(data) }
                            errorAlert.accept(error.localizedDescription)
                        return Single.just(data)
                    }
            }
            .bind(with: self) { owner, value in
                let result = owner.convertToSectionModel(value)
                sectionModel.accept(result)
            }
            .disposed(by: disposeBag)
        
        input.searchButtonTap
            .withLatestFrom(input.searchText)
            .bind(with: self) { owner, value in
                LoadingIndicator.showLoading()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    LoadingIndicator.hideLoading()
                }
                
                guard let text = value?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                    searchText.accept("")
                    return
                }
                searchText.accept(text)
            }
            .disposed(by: disposeBag)
        
        input.coinCellTap
            .bind {
                LoadingIndicator.showLoading()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    LoadingIndicator.hideLoading()
                }
                detailValue.accept($0)
            }
            .disposed(by: disposeBag)
        
        
        return Output(sectionModel: sectionModel.asDriver(onErrorJustReturn: []),
                      searchText: searchText.asDriver(onErrorJustReturn: ""),
                      detailValue: input.coinCellTap.asDriver(),
                      errorAlert: errorAlert.asDriver(onErrorJustReturn: "")
        )
    }
    
    private func convertToSectionModel(_ data: Trending) -> [TrendingSectionModel] {
        let formatter = FormatManager.shared
        
        var coinList = [TrendingSectionItem]()
        var nftList = [TrendingSectionItem]()
        let coinHeader = ("인기 검색어", formatter.trendingDateFormatted())
        let nftHeader = "인기 NFT"
        
        data.coins.forEach {
            let changeResult = formatter.roundDecimal($0.item.data.change.krw, isArrow: true)
            coinList.append(
                .coin(model: CoinItem(
                    id: $0.item.id,
                    score: "\($0.item.score + 1)",
                    symbol: $0.item.symbol,
                    name: $0.item.name,
                    change: changeResult.str + "%",
                    changeColor: changeResult.color,
                    image: $0.item.thumb)
                )
            )
        }
        coinList.popLast()
        
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
