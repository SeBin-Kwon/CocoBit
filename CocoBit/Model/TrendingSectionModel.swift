//
//  TrendingSectionModel.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/9/25.
//

import Foundation
import RxDataSources

enum TrendingSectionItem {
    case coin(model: CoinItem)
    case nft(model: NFTItem)
}

enum TrendingSectionModel {
    case coinSection(header: (String, String), data: [TrendingSectionItem])
    case nftSection(header: String, data: [TrendingSectionItem])
}

struct CoinItem {
    let id: String
    let score: String
    let symbol: String
    let name: String
    let change: String
    let changeColor: DecimalState
    let image: String
}

struct NFTItem {
    let name: String
    let price: String
    let change: String
    let changeColor: DecimalState
    let image: String
}

extension TrendingSectionModel: SectionModelType {
    typealias Item = TrendingSectionItem
    
    var header: (title: String, time: String?) {
        switch self {
        case .coinSection(let header, _): header
        case .nftSection(let header, _): (header, nil)
        }
    }
    
    var items: [TrendingSectionItem] {
        switch self {
        case .coinSection(_, let items): items
        case .nftSection(_, let items): items
        }
    }
    
    init(original: Self, items: [Self.Item]) {
        self = original
    }
}
