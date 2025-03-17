//
//  NetworkManager.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/7/25.
//

import Foundation
import Alamofire
import RxSwift

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchResults<T: Decodable>(api: EndPoint, type: T.Type) -> Single<T> {
        return Single<T>.create { value in
            
            if NetworkMonitor.shared.isStartMonitor {
                NetworkMonitor.shared.startMonitoring()
                NetworkMonitor.shared.isStartMonitor = false
            }
            
            AF.request(api.endPoint, method: api.method, parameters: api.parameter, encoding: URLEncoding(destination: .queryString))
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let result):
                        value(.success(result))
                    case .failure(let error):
                        let apiError: Error
                        guard let code = error.responseCode else { return }
                        switch api.error {
                        case is UpbitError.Type:
                            apiError = UpbitError(rawValue: code) ?? UpbitError.server
                        case is CoinGeckoError.Type:
                            apiError = UpbitError(rawValue: code) ?? UpbitError.server
                        default:
                            apiError = NetworkError.unknown
                        }
                        
                        value(.failure(apiError))
                    }
                }
            return Disposables.create {}
        }
    }
}
