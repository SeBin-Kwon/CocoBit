//
//  Error.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/16/25.
//

import Foundation

enum UpbitError: Int, Error {
    case badRequest = 400
    case unauthorized = 401
    case server = 500
}

extension UpbitError: LocalizedError {
    
    var title: String {
        switch self {
        case .badRequest: return "잘못된 요청"
        case .unauthorized: return "인증 실패"
        case .server: return "시스템 에러"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .badRequest: return "잘못된 요청입니다.\nUpbit에 올바른 요청으로 다시 시도해 주세요."
        case .unauthorized: return "Upbit 서비스에 액세스할 수 있는\n권한이 없습니다."
        case .server: return "Upbit 서버 내부에 오류가 발생했습니다.\n개발자 포럼에 오류를 신고해 주십시오."
        }
    }
}

enum CoinGeckoError: Int, Error {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case tooManyRequests = 429
    case server = 500
}

extension CoinGeckoError: LocalizedError {
    
    var title: String {
        switch self {
        case .badRequest: return "잘못된 요청"
        case .unauthorized: return "인증 실패"
        case .forbidden: return "금지됨"
        case .notFound: return "찾을 수 없음"
        case .tooManyRequests: return "과호출"
        case .server: return "시스템 에러"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .badRequest: return "잘못된 요청입니다.\nCoinGecko에 올바른 요청으로 다시 시도해 주세요."
        case .unauthorized: return "CoinGecko 서비스에 액세스할 수 있는\n권한이 없습니다."
        case .forbidden: return "귀하의 엑세스가 CoinGecko에서 차단되어\n요청을 승인할 수 없습니다."
        case .notFound: return "CoinGecko에서 요청하신 리소스를 찾을 수 없습니다."
        case .tooManyRequests: return "CoinGecko API 요금 한도에 도달하였습니다.\n서비스 플랜을 확장해 주세요."
        case .server: return "CoinGecko 서버 내부에 오류가 발생했습니다.\n개발자 포럼에 오류를 신고해 주십시오."
        }
    }
}

enum NetworkError: Error, LocalizedError {
    case noConnection
    case unknown

    var errorDescription: String? {
        switch self {
        case .noConnection:
            return "네트워크 연결이 일시적으로 원활하지\n않습니다. 데이터 또는 Wi-Fi 연결 상태를\n확인해주세요."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다.\n잠시 후 다시 시도해주세요."
        }
    }
}

