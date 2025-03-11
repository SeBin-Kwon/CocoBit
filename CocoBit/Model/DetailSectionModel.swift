//
//  DetailSectionModel.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/11/25.
//

import Foundation
import RxDataSources

enum DetailSectionItem {
    case chart(model: ChartItem)
    case stock(model: StockItem)
    case investment(model: InvestmentItem)
}

enum DetailSectionModel {
    case chartSection(data: [DetailSectionItem])
    case stockSection(header: String, data: [DetailSectionItem])
    case investmentSection(header: String, data: [DetailSectionItem])
}

struct ChartItem {
    let crrentPrice: String
    let change24h: String
    let changeColor: DecimalState
    let lastUpdated: String
    let chartArray: [Double]
}

struct StockItem {
    let title: String
    let value: String
    let date: String
}

struct InvestmentItem {
    let title: String
    let value: String
}

extension DetailSectionModel: SectionModelType {
    typealias Item = DetailSectionItem
    
    var header: String {
        switch self {
        case .stockSection(let header, _): header
        case .investmentSection(let header, _): header
        default: ""
        }
    }
    
    var items: [DetailSectionItem] {
        switch self {
        case .chartSection(let items): items
        case .stockSection(_, let items): items
        case .investmentSection(_, let items): items
        }
    }
    
    init(original: Self, items: [Self.Item]) {
        self = original
    }
}
