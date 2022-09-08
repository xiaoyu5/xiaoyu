//
//  SocketConnectParam.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/25.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

public struct SocketConnectParam {
    
    let host:String
    
    let port:UInt16
    
    var timeout:TimeInterval = 15.0
    
    var heartbeatEnabled:Bool = true
    
    var heartbeatInterval:TimeInterval = 20.0
    
    var autoReconnect:Bool = false
    
    public init(_ host:String, port:UInt16) {
        
        self.host = host
        self.port = port
    }
}
