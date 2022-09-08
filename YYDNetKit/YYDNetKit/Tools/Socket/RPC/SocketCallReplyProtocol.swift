//
//  SocketCallReplyProtocol.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/29.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

public protocol SocketCallProtocol {
    
    var request: SocketUpstreamPacket {get set}
}

public protocol SocketReplyProtocol {
    
    func onSuccess(_ aCallReply:SocketCallReplyProtocol, response:SocketDownstreamPacket?)
    
    func onFailure(_ aCallReply:SocketCallReplyProtocol, error:Error?)
}


public protocol SocketCallReplyProtocol: SocketCallProtocol, SocketReplyProtocol {
    
    var callReplyIdentify:String { get }
    var callReplyTimeout:TimeInterval {get}
    
    var isTimeout:Bool {get}
}


extension SocketCallReplyProtocol {
    
    public var callReplyIdentify: String {
        get {
            return self.request.pid ?? ""
        }
    }
    
    public var callReplyTimeout: TimeInterval {
        get {
            if self.request.timeout < 0 {
                return TimeInterval.greatestFiniteMagnitude
            }
            return self.request.timeout
        }
    }
    
    public var isTimeout: Bool {
        get {
            return false
        }
    }
    
}
