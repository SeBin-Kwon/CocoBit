//
//  NetworkManager.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/7/25.
//

import Foundation
import Alamofire
import RxSwift

enum APIError: Int, Error {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case server = 500
}

extension APIError: LocalizedError {
    
    var title: String {
        switch self {
        case .badRequest: return "잘못된 요청"
        case .unauthorized: return "인증 실패"
        case .forbidden: return "금지됨"
        case .notFound: return "찾을 수 없음"
        case .server: return "시스템 에러"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .badRequest: return "잘못된 매개변수입니다."
        case .unauthorized: return "서비스에 액세스할 수 있는 권한이 없습니다."
        case .forbidden: return "검색 API 권한이 없습니다."
        case .notFound: return "요청하신 리소스를 찾을 수 없습니다."
        case .server: return "서버 내부에 오류가 발생했습니다.\n개발자 포럼에 오류를 신고해 주십시오."
        }
    }
}

final class NetworkManager {
    

}
