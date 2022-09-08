//
//  SocketJSONEncoder.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/27.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

public struct SocketJSONEncoder:SocketEncoderProtocol {
    
    public var nextEncoder:SocketEncoderProtocol?
    
    public init() {}
    
    public func encode(_ packet: SocketUpstreamPacket, output: SocketEncoderOutputProtocol) {
        
        var upstreamPacket = packet
        var dataObject:Data? = nil
        
        switch upstreamPacket.object {
        case let data as Data:
            dataObject = data
        case let string as String:
            dataObject = string.jsonDict()?.jsonData()
        case let dictionary as [String:Any]:
            dataObject = dictionary.jsonData()
        default:
            print("[Encoder] object convert to data error")
        }
        
        if let nextEncoder = nextEncoder {
            upstreamPacket.object = dataObject
            nextEncoder.encode(upstreamPacket, output: output)
            return
        }
        
        output.didEncode(dataObject, timeout: upstreamPacket.timeout)
    }
}
