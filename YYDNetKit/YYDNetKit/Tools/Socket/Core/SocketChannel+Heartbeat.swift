//
//  SocketChannel+Heartbeat.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/29.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

extension SocketChannel:SocketChannelHeartbeatProtocol {
    
    private struct CustomProperties {
        static var heartbeat: SocketUpstreamPacket? = nil
        static var heartbeatTimer: Timer? = nil
    }
    
    public var heartbeat: SocketUpstreamPacket? {
        get {
            return objc_getAssociatedObject(self, &CustomProperties.heartbeat) as? SocketPacketRequest
        }
        set {
            if let unwrappedValue = newValue {
                objc_setAssociatedObject(self, &CustomProperties.heartbeat, unwrappedValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    public var heartbeatTimer: Timer? {
        get {
            return objc_getAssociatedObject(self, &CustomProperties.heartbeatTimer) as? Timer
        }
        set {
            if let unwrappedValue = newValue {
                objc_setAssociatedObject(self, &CustomProperties.heartbeatTimer, unwrappedValue as Timer?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    public func startHeartbeatTimer(_ timeinterval: TimeInterval) {
        
        let minInterval = max(5, timeinterval)
        
        self.stopHeartbeatTimer()
        
        self.heartbeatTimer = Timer.scheduledTimer(timeInterval: minInterval, target: self, selector: #selector(SocketChannel.heartbeatTimerFunction), userInfo: nil, repeats: true)
    }
    
    public func stopHeartbeatTimer() {
        
        if let timer = self.heartbeatTimer {
            timer.invalidate()
            self.heartbeatTimer = nil
        }
    }
    
    public func sendHeartbeat() {
        
        if let heart = self.heartbeat {
            self.asyncSendPacket(heart)
        }
    }
    
    @objc public func heartbeatTimerFunction() {
        
        self.sendHeartbeat()
    }
    
}
