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
    
    // 소수점 2자리 표기
    private let numberFormatter = {
       let format = NumberFormatter()
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
    
    // 정수, 소수점 표기 + 색깔
    func roundDecimal(_ value: Double, isArrow: Bool) -> (str: String, color: DecimalState) {
        let state: DecimalState
        
        if value == Double(Int(value)) {
            let result = Int(value).formatted()
            return (result, .zero)
        }
        
        switch value {
        case ..<0:
            state = .down
        case 0...:
            state = .up
        default: state = .zero
        }
        
        let result = numberFormatter.string(for: value) ?? "0"
        
        if isArrow && state == .down {
            return (String(result.dropFirst()), state)
        }
        
        return (result, state)
    }
    
    // 현재가 소수점 1자리 표기
    func tradeFormatted(_ value: Double) -> String {
        if value == Double(Int(value)) {
            let result = Int(value).formatted()
            return result
        }
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
    
    // 디테일 돈 표기
    func detailPriceFormatted(_ value: Double) -> String {
        if value == Double(Int(value)) {
            let result = Int(value).formatted()
            return "₩" + result
        } else {
            return "₩" + (numberFormatter.string(for: value) ?? "0")
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
    
    // 상세화면 업데이트 날짜 표기
    func detailUpdateFormatted(_ value: String) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-DD'T'HH:mm:ss.SSSZZZZZ"
        let date = format.date(from: value)
        format.dateFormat = "M/dd HH:mm:ss 업데이트"
        if let date {
            return format.string(from: date)
        } else {
            return "없음"
        }
    }
    
    // 상세화면 종목 날짜 표기
    func detailDateFormatted(_ value: String) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-DD'T'HH:mm:ss.SSSZZZZZ"
        let date = format.date(from: value)
        format.dateFormat = "yy년 M월 d일"
        if let date {
            return format.string(from: date)
        } else {
            return "없음"
        }
    }
    
}
