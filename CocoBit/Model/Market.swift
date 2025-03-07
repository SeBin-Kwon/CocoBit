//
//  Market.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/7/25.
//

import Foundation

struct Market: Decodable {
    let marketArray: [MarketData]
}

struct MarketData: Decodable {
    let market: String
    let tradePrice: Double
    let signedChangePrice: Double
    let signedChangeRate: Double
    let accTradePrice24h: Double
    
    enum CodingKeys: String, CodingKey {
        case market
        case tradePrice = "trade_price"
        case signedChangePrice = "signed_change_price"
        case signedChangeRate = "signed_change_rate"
        case accTradePrice24h = "acc_trade_price_24h"
    }
}
