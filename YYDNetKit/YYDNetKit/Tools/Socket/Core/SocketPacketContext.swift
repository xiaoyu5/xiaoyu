//
//  SocketPacketContext.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/26.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation


public struct SocketPacketRequest:SocketUpstreamPacket, CustomDebugStringConvertible {
    
    public var pid: String?
    
    public var timeout: TimeInterval = -1
    
    public var object: Any?
    
    public init(){}
    
    public var debugDescription: String {
        return "[SocketPacketRequest] pid:\(String(describing: pid)) timeout:\(timeout) object:\(String(describing: object))"
    }
}

public struct SocketPacketResponse:SocketDownstreamPacket {
    
    public var pid: String?
    
    public var object: Any?
}
