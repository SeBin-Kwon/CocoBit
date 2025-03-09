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
    let symbol: String
    let name: String
    let thumb: String
    let data: TrendingCoinData
}

struct TrendingCoinData: Decodable {
    let price_change_percentage_24h: coinChangeData
}

struct coinChangeData: Decodable {
    let krw: Double
}

struct TrendingNFTItem: Decodable {
    let symbol: String
    let name: String
    let thumb: String
    let floor_price_24h_percentage_change: Double
    let data: TrendingNFTData
}

struct TrendingNFTData: Decodable {
    let floor_price: String
}
