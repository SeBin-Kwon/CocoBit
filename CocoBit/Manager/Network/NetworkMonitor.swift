//
//  NetworkMonitor.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/7/25.
//

import Foundation
import Network
import RxSwift
import RxCocoa

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    public private(set) var connectionType: ConnectionType = .unknown
    
    public private(set) var isPopUp = BehaviorRelay(value: false)
    
    enum ConnectionType{
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init(){
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring(){
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            
            self?.isConnected = path.status == .satisfied
            self?.getConnectionType(path)
            
            if self?.isConnected == true {
                print("네트워크연결됨")
                self?.isPopUp.accept(true)
            } else {
                print("네트워크 연결 오류")
                self?.isPopUp.accept(false)
            }
            
        }
    }
    
    public func stopMonitoring(){
        monitor.cancel()
    }
    
    private func getConnectionType(_ path: NWPath){
        if path.usesInterfaceType(.wifi){
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular){
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet){
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
}
