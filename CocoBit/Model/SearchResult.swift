//
//  SearchResult.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/10/25.
//

import Foundation

struct SearchResult: Decodable {
    let coins: [SearchData]
}

struct SearchData: Decodable {
    let id: String
    let symbol: String
    let name: String
    let thumb: String
    let rank: Int?
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case thumb
        case rank = "market_cap_rank"
    }
}
