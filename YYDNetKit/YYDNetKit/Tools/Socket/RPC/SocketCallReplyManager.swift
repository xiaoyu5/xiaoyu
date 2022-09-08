//
//  SocketCallReplyManager.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/29.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

public class SocketCallReplyManager {
    
    fileprivate var callReplyMap: [String:SocketCallReplyProtocol] = [:]
    fileprivate var checkQueue:DispatchQueue = DispatchQueue.init(label: "com.yyd.SocketCallReplyCheck")
    fileprivate var checkTimer:GCDTimer?
    
    public func addCallReply(_ aCallReply:SocketCallReplyProtocol) {
        
        
    }
    
    fileprivate func startRefreshTimer() {
        
        self.stopRefreshTimer()
        
        if self.checkTimer == nil {
            self.checkTimer = GCDTimer.init(interval: .seconds(1), repeats: true, leeway: .seconds(1), queue: self.checkQueue, handler: { (timer) in
                
                self.checkTimeout()
            })
        }
        
        self.checkTimer?.start()
    }
    
    fileprivate func stopRefreshTimer() {
        
        self.checkTimer?.suspend()
    }
    
    
    fileprivate func checkTimeout() {
        
        synchronized(lock: self) {
            
            var timeoutCalls:[SocketCallReplyProtocol] = []
            // TODO
        }
    }
}
