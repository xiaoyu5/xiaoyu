//
//  SocketTextDecoder.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/27.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

struct SocketTextDecoder:SocketDecoderProtocol {
    
    var nextDecoder:SocketDecoderProtocol?
    
    func decode<T>(_ packet: inout T, output: SocketDecoderOutputProtocol) -> Int where T : SocketDownstreamPacket {
        
        var stringObject:String? = nil
        
        switch packet.object {
        case let data as Data:
            stringObject = String.init(data: data, encoding: .utf8)
        case let string as String:
            stringObject = string
        default:
            print("[Decoder] object convert to string error")
        }
        
        packet.object = stringObject
        
        if stringObject == nil {
            print("[Decoder] object convert to string error")
        }
        
        if let nextDeocoder = nextDecoder {
            return nextDeocoder.decode(&packet, output: output)
        }
        
        output.didDecode(packet)
        
        return 0
    }
}
