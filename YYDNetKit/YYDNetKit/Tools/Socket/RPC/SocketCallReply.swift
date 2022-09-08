//
//  SocketCallReply.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/29.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

public typealias SocketReplySuccess = (_ callReply:SocketCallReplyProtocol, _ response:SocketDownstreamPacket?)->Void
public typealias SocketReplyFailure = (_ callReply:SocketCallReplyProtocol, _ error:Error?)->Void

public struct SocketCallReply: SocketCallReplyProtocol {
    
    public var request: SocketUpstreamPacket
    
    fileprivate var successClosure:SocketReplySuccess?
    fileprivate var faileClosure:SocketReplyFailure?
    
    public func onSuccess(_ aCallReply: SocketCallReplyProtocol, response: SocketDownstreamPacket?) {
        
        print("[onSuccess] response::\(response))")
        
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
    
    public init(withRequest request:SocketUpstreamPacket) {
        self.request = request
    }
    public init(withRequest request:SocketUpstreamPacket ,successClosure:@escaping SocketReplySuccess, faileClosure:@escaping SocketReplyFailure) {
        
        self.request = request
        self.successClosure = successClosure
        self.faileClosure = faileClosure
    }
}
