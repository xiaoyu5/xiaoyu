//
//  SocketChannelHeartbeatProtocol.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/29.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

public protocol SocketChannelHeartbeatProtocol {
    
    var heartbeat:SocketUpstreamPacket? { get set }
    
    var heartbeatTimer:Timer? { get set }
    
    func startHeartbeatTimer(_ timeinterval:TimeInterval)
    
    func stopHeartbeatTimer()
    
    func sendHeartbeat()
    
    func heartbeatTimerFunction()
}
