//
//  Trending.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/9/25.
//

import Foundation

struct Trending: Decodable {
    let coins: [TrendingCoin]
    let nfts: [TrendingNFTItem]
}

struct TrendingCoin: Decodable {
    let item: TrendingCoinItem
}

struct TrendingCoinItem: Decodable {
    let id: String
    let score: Int
    let symbol: String
    let name: String
    let thumb: String
    let data: TrendingCoinData
}

struct TrendingCoinData: Decodable {
    let change: coinChangeData
    
    enum CodingKeys: String, CodingKey {
        case change = "price_change_percentage_24h"
    }
}

struct coinChangeData: Decodable {
    let krw: Double
}

struct TrendingNFTItem: Decodable {
    let symbol: String
    let name: String
    let thumb: String
    let change: Double
    let data: TrendingNFTData
    
    enum CodingKeys: String, CodingKey {
        case symbol
        case name
        case thumb
        case change = "floor_price_24h_percentage_change"
        case data
    }
}

struct TrendingNFTData: Decodable {
    let price: String
    
    enum CodingKeys: String, CodingKey {
        case price = "floor_price"
    }
}
