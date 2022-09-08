//
//  SocketPacket.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/26.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

public protocol SocketPacketProtocol {
    
    var object:Any? { get set }
    
    var pid:String? {get set}
    
    var objData:Data? { get }
    
    var objString:String? { get }
}

extension SocketPacketProtocol {
    
    public var objData: Data? {
        get {
            switch object {
            case let data as Data:
                return data
            case let string as String:
                return string.data(using: .utf8)
            default:
                return nil
            }
        }
    }
    
    public var objString: String? {
        get {
            switch object {
            case let data as Data:
                return String.init(data: data, encoding: .utf8)
            case let string as String:
                return string
            default:
                return nil
            }
        }
    }
    
    
}


public protocol SocketUpstreamPacket:SocketPacketProtocol {
    
    var timeout:TimeInterval { get set }
}


public protocol SocketDownstreamPacket:SocketPacketProtocol {
    
    
}
