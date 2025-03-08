//
//  FormatManager.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/7/25.
//

import Foundation

final class FormatManager {
    static let shared = FormatManager()
    
    // 소수점 2자리 표기 + 콤마
    private let numberFormatter = {
       let format = NumberFormatter()
        format.numberStyle = .decimal
        format.maximumFractionDigits = 2
        format.minimumFractionDigits = 2
        return format
    }()
    private init() {}
    
    // 소수점 표기 + 색깔
    func roundDecimal(_ value: Double) -> (String, DecimalState) {
        let state: DecimalState
        
        switch value {
        case ..<0:
            state = .down
        case 0...:
            state = .up
        default: state = .zero
        }
        
        let result = numberFormatter.string(for: value) ?? "0"
        
        if result == "0.00" || result == "-0.00" {
            return (result.components(separatedBy: "-").joined(), .zero)
        }
        
        return (result, state)
    }
    
    // 현재가 소수점 1자리 표기
    func tradeFormatted(_ value: Double) -> String {
        var num = numberFormatter.string(for: value) ?? "0"
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
