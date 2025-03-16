//
//  EndPoint.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/7/25.
//

import Foundation
import Alamofire

enum EndPoint {
    case market(currency: MarketCurrency)
    case trending
    case searchResult(query: String)
    case detail(currency: MarketCurrency, id: String)
    
    var baseURL: String {
        switch self {
        case .market: "https://api.upbit.com/v1/ticker"
        case .trending, .searchResult, .detail: "https://api.coingecko.com/api/v3"
        }
    }
    
    var method: HTTPMethod { .get }
    
    var endPoint: String {
        switch self {
        case .market: baseURL + "/all"
        case .trending: baseURL + "/search/trending"
        case .searchResult: baseURL + "/search"
        case .detail: baseURL + "/coins/markets"
        }
    }
    
    var parameter: Parameters? {
        switch self {
        case .market(let currency): ["quote_currencies" : currency.rawValue]
        case .searchResult(let query): ["query" : query]
        case .detail(let currency, let id): ["vs_currency": currency.detail, "ids": id, "sparkline": "true"]
        case .trending: nil
        }
    }
    
    var error: Error.Type {
        switch self {
        case .market: UpBitError.self
        case .trending, .searchResult, .detail: CoinGeckoError.self
        }
    }
}

enum MarketCurrency: String {
    case KRW
    var detail: String {
        switch self {
        case .KRW: "krw"
        }
    }
}
