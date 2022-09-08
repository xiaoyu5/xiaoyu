//
//  SwiftTimer.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/29.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

class GCDTimer {
    
    private let internalTimer: DispatchSourceTimer
    
    private var isRunning = false
    
    public let repeats: Bool
    
    public typealias SwiftTimerHandler = (GCDTimer) -> Void
    
    private var handler: SwiftTimerHandler
    
    init(interval: DispatchTimeInterval, repeats: Bool = false, leeway: DispatchTimeInterval = .seconds(0), queue: DispatchQueue = .main , handler: @escaping SwiftTimerHandler) {
        
        self.handler = handler
        self.repeats = repeats
        internalTimer = DispatchSource.makeTimerSource(queue: queue)
        internalTimer.setEventHandler { [weak self] in
            if let strongSelf = self {
                handler(strongSelf)
            }
        }
        
        if repeats {
            internalTimer.schedule(deadline: .now() + interval, repeating: interval, leeway: leeway)
        } else {
            internalTimer.schedule(deadline: .now() + interval, leeway: leeway)
        }
    }
    
    static func repeaticTimer(interval: DispatchTimeInterval, leeway: DispatchTimeInterval = .seconds(0), queue: DispatchQueue = .main , handler: @escaping SwiftTimerHandler ) -> GCDTimer {
        return GCDTimer(interval: interval, repeats: true, leeway: leeway, queue: queue, handler: handler)
    }
    
    deinit {
        if !self.isRunning {
            internalTimer.resume()
        }
    }
    
    //You can use this method to fire a repeating timer without interrupting its regular firing schedule. If the timer is non-repeating, it is automatically invalidated after firing, even if its scheduled fire date has not arrived.
    func fire() {
        if repeats {
            handler(self)
        } else {
            handler(self)
            internalTimer.cancel()
        }
    }
    
    func start() {
        if !isRunning {
            internalTimer.resume()
            isRunning = true
        }
    }
    
    func suspend() {
        if isRunning {
            internalTimer.suspend()
            isRunning = false
        }
    }
    
    func rescheduleRepeating(interval: DispatchTimeInterval) {
        if repeats {
            internalTimer.schedule(deadline: .now() + interval, repeating: interval)
        }
    }
    
    func rescheduleHandler(handler: @escaping SwiftTimerHandler) {
        self.handler = handler
        internalTimer.setEventHandler { [weak self] in
            if let strongSelf = self {
                handler(strongSelf)
            }
        }
        
    }
}
