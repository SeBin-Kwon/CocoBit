//
//  DetailData.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/10/25.
//

import Foundation

struct DetailData: Decodable {
    let id: String
    let image: String
    let name: String
    let symbol: String
    let crrentPrice: Double
    let change24h: Double
    let lastUpdated: String
    let high24h: Double
    let low24h: Double
    let ath: Double
    let athDate: String
    let atl: Double
    let atlDate: String
    let marketCap: Double
    let fullyValuation: Double
    let totalVolum: Double
    let sparklineIn7d: Sparkline
    
    enum CodingKeys: String, CodingKey {
        case id
        case image
        case name
        case symbol
        case crrentPrice = "current_price"
        case change24h = "price_change_percentage_24h"
        case lastUpdated = "last_updated"
        case high24h = "high_24h"
        case low24h = "low_24h"
        case ath
        case athDate = "ath_date"
        case atl
        case atlDate = "atl_date"
        case marketCap = "market_cap"
        case fullyValuation = "fully_diluted_valuation"
        case totalVolum = "total_volume"
        case sparklineIn7d = "sparkline_in_7d"
    }
}

struct Sparkline: Decodable {
    let price: [Double]
}
