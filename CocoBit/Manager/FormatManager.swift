//
//  FormatManager.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/7/25.
//

import Foundation

final class FormatManager {
    static let shared = FormatManager()

    private init() {}
    
    // 소수점 2자리 표기 + 콤마
    private let numberFormatter = {
       let format = NumberFormatter()
        format.numberStyle = .decimal
        format.maximumFractionDigits = 2
        format.minimumFractionDigits = 2
        return format
    }()
    
    // 인기검색어 날짜
    private let trendingDateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "MM.dd HH:mm 기준"
        return format
    }()
    
    // 상세화면 날짜
    private let detailDateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "M/dd HH:mm:ss 업데이트"
        return format
    }()
    
    // 소수점 표기 + 색깔
    func roundDecimal(_ value: Double, isArrow: Bool) -> (str: String, color: DecimalState) {
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
        
        if isArrow && state == .down {
            return (String(result.dropFirst()), state)
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
    
    // 인기검색어 날짜 표기
    func trendingDateFormatted() -> String {
        trendingDateFormatter.string(from: Date())
    }
    
    // 상세화면 날짜 표기
    func detailDateFormatted() -> String {
        detailDateFormatter.string(from: Date())
    }
    
}
