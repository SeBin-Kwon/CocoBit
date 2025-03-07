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
    
    var baseURL: String {
        switch self {
        case .market: "https://api.upbit.com/v1/ticker/all"
        }
    }
    
    var method: HTTPMethod { .get }
    
    var endPoint: String {
        switch self {
        case .market: ""
        }
    }
    
    var parameter: Parameters? {
        switch self {
        case .market(let currency): ["quote_currencies" : currency.rawValue]
        }
    }
}

enum MarketCurrency: String {
    case KRW
}
