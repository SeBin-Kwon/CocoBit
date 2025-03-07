//
//  FormatManager.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/7/25.
//

import Foundation

final class FormatManager {
    static let shared = FormatManager()
    private let numberFormatter = NumberFormatter()
    private init() {}
    
    // 기본 소수점 2자리 표기 + 콤마
    func roundDecimal(_ value: Double) -> String {
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        let result = numberFormatter.string(for: value) ?? "0"
        return result
    }
    
    // 현재가 소수점 1자리 표기
    func tradeFormatted(_ value: Double) -> String {
        var num = roundDecimal(value)
        if num.last == "0" {
            num.removeLast()
        }
        return num
    }
    
    // 거래대금 표기
    func convertToMillions(_ value: Double) -> String {
        if value >= 1000000 {
            return trunc(value/1000000).formatted() + "백만"
        } else {
            return trunc(value).formatted()
        }
    }
    
    // 마켓 코인 표기
    func marketFormatted(_ value: String) -> String {
        let splitString = value.components(separatedBy: "-")
        return splitString[1] + "/" + splitString[0]
    }
    
}
