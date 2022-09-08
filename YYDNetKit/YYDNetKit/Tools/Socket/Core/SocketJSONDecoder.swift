//
//  SocketJSONDecoder.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/27.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

public struct SocketJSONDecoder:SocketDecoderProtocol {
    
    var nextDecoder:SocketDecoderProtocol?
    
    public init() {
        
    }
    
    public func decode<T>(_ packet: inout T, output: SocketDecoderOutputProtocol) -> Int where T : SocketDownstreamPacket {
        
        var dictionaryObject:[String:Any]? = nil
        
        switch packet.object {
        case let data as Data:
            dictionaryObject = data.jsonDict()
        case let string as String:
            dictionaryObject = string.jsonDict()
        case let dictionary as [String:Any]:
            dictionaryObject = dictionary
        default:
            print("[Decoder] object convert to dictionary error")
        }
        
        packet.object = dictionaryObject
        
        if dictionaryObject == nil {
            print("[Decoder] object convert to dictionary error")
        }
        
        if let nextDeocoder = nextDecoder {
            return nextDeocoder.decode(&packet, output: output)
        }
        
        output.didDecode(packet)
        
        return 0
    }
}
