//
//  SocketConnectionProtocol.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/26.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

protocol SocketConnectionProtocol {
    
    var isConnected:Bool { get }
    
    var connectParam:SocketConnectParam { get set }
    
    var socketQueue:DispatchQueue { get }
    
    var isOnSocketQueue:Bool { get }
    
    func connect()
    
    func disconnect()
    
    func didConnect(toHost host:String, port:UInt16)
    func didDisconnect(withError error:Error?)
    
    func didRead(withData data:Data, tag:Int)
    
    func didReceived(_ packet:SocketDownstreamPacket)
}

fileprivate let _IsOnSocketQueueOrTargetQueueKey:DispatchSpecificKey = DispatchSpecificKey<Void>.init()

extension SocketConnectionProtocol {
    
    var socketQueue:DispatchQueue {
        get {
            let queue = DispatchQueue.init(label: "com.yyd.socket.RHSocketQueueSpecific")
            queue.setSpecific(key: _IsOnSocketQueueOrTargetQueueKey, value: ())
            return queue
        }
    }
    
    var isOnSocketQueue:Bool {
        get {
            return (self.socketQueue.getSpecific(key: _IsOnSocketQueueOrTargetQueueKey) != nil)
        }
    }
}
