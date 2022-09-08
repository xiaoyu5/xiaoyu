//
//  SocketConnect.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/25.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

public class SocketConnection:NSObject, SocketConnectionProtocol {
    
    var connectParam: SocketConnectParam
    
    fileprivate var asyncSocket:GCDAsyncSocket?
    
    var isConnected: Bool {
        get {
            var result = false
            self.dispatchOnSocketQueue(withClosure: {
                result = self.asyncSocket?.isConnected ?? false
            }, isAsync: false)
            return result
        }
    }
    
    public init(withParam connectParam: SocketConnectParam) {
        self.connectParam = connectParam
        super.init()
    }
    // MARK: public func
    public func connect() {
        
        guard self.connectParam.host != "" else {
            fatalError("host is null")
        }
        guard self.connectParam.port > 0 else {
            fatalError("port is 0")
        }
        
        self.dispatchOnSocketQueue(withClosure: { [weak self] in
            
            guard let strongself = self else {return}
            
            strongself.asyncSocket = GCDAsyncSocket.init(delegate: self, delegateQueue: self?.socketQueue)
            
            strongself.asyncSocket?.isIPv4PreferredOverIPv6 = false
            
            let host = strongself.connectParam.host
            let port = strongself.connectParam.port
            do {
                try strongself.asyncSocket?.connect(toHost: host, onPort: port)
            }catch let err {
                strongself.didDisconnect(withError: err)
            }
            
            }, isAsync: true)
    }
    
    public func disconnect() {
        
        self.dispatchOnSocketQueue(withClosure: { [weak self] in
            
            if self?.asyncSocket != nil {
                self?.asyncSocket?.disconnect()
                self?.asyncSocket?.delegate = nil
                self?.asyncSocket = nil
            }
            
            }, isAsync: true)
    }
    
    public func read(withTimeout timeout:TimeInterval, tag:Int) -> Void {
        
        self.dispatchOnSocketQueue(withClosure: { [weak self] in
            
            if let client = self?.asyncSocket {
                client.readData(withTimeout: timeout, tag: tag)
            }
            
            }, isAsync: true)
    }
    public func write(data:Data, timeout:TimeInterval, tag:Int) -> Void {
        
        self.dispatchOnSocketQueue(withClosure: { [weak self] in
            
            if let client = self?.asyncSocket {
                client.write(data, withTimeout: timeout, tag: tag)
            }
            
            }, isAsync: true)
    }
    
    func didConnect(toHost host: String, port: UInt16) {
        print("didConnect: \(host):\(port)")
    }
    func didDisconnect(withError error: Error?) {
        print("didDisconnect: \(String(describing: error))")
    }
    func didRead(withData data: Data, tag: Int) {
        print("didRead: \(data.count))")
    }
    func didReceived(_ packet: SocketDownstreamPacket) {
        if let data = packet.objData {
            let dataStr = String.init(data: data, encoding: .utf8)
            print("didReceived: \(String(describing: dataStr)))")
        }else {
            print("didReceived: null)")
        }
    }
    // MARK: private func
    func dispatchOnSocketQueue(withClosure closure:@escaping (() -> Void), isAsync:Bool) -> Void {
        
        if self.isOnSocketQueue {
            autoreleasepool(invoking: { () -> Void in
                
                closure()
            })
            return
        }
        
        if isAsync {
            self.socketQueue.async {
                autoreleasepool(invoking: { () -> Void in
                    
                    closure()
                })
            }
        }else {
            self.socketQueue.sync {
                autoreleasepool(invoking: { () -> Void in
                    
                    closure()
                })
            }
        }
    }
}


// MARK: - GCDAsyncSocketDelegate
extension SocketConnection: GCDAsyncSocketDelegate {
    
    public func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        
        self.didConnect(toHost: host, port: port)
    }
    
    public func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        
        self.didDisconnect(withError: err)
    }
    
    public func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        self.didRead(withData: data, tag: tag)
        
        sock.readData(withTimeout: -1, tag: tag)
    }
    
    public func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        
        sock.readData(withTimeout: -1, tag: tag)
    }
}
