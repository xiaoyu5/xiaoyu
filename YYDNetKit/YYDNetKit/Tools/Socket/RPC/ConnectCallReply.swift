//
//  ConnectCallReply.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/29.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

public struct ConnectCallReply:SocketCallReplyProtocol {
    
    public var host:String
    public var port:UInt16
    
    public var request: SocketUpstreamPacket
    
    fileprivate var successClosure:SocketReplySuccess?
    fileprivate var faileClosure:SocketReplyFailure?
    
    public func onSuccess(_ aCallReply: SocketCallReplyProtocol, response: SocketDownstreamPacket?) {
        
        print("[onSuccess] response::\(String(describing: response)))")
        
        if let success = self.successClosure {
            success(aCallReply, response)
        }
    }
    
    public func onFailure(_ aCallReply: SocketCallReplyProtocol, error: Error?) {
        
        print("[onFailure] error:\(String(describing: error))")
        
        if let failure = self.faileClosure {
            failure(aCallReply, error)
        }
    }
    
    public init(withRequest request:SocketUpstreamPacket, host:String, port:UInt16) {
        self.request = request
        self.host = host
        self.port = port
    }
    public init(withRequest request:SocketUpstreamPacket ,successClosure:@escaping SocketReplySuccess, faileClosure:@escaping SocketReplyFailure, host:String, port:UInt16) {
        
        self.request = request
        self.successClosure = successClosure
        self.faileClosure = faileClosure
        self.host = host
        self.port = port
    }
}
