//
//  SocketCodecProtocol.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/26.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

public protocol SocketEncoderProtocol {
    
    func encode(_ packet:SocketUpstreamPacket, output:SocketEncoderOutputProtocol)
}

public protocol SocketEncoderOutputProtocol {
    
    func didEncode(_ encodeData:Data?, timeout:TimeInterval)
}

public protocol SocketDecoderProtocol {
    
    func decode<T: SocketDownstreamPacket>(_ packet:inout T, output: SocketDecoderOutputProtocol) -> Int
}


public protocol SocketDecoderOutputProtocol {
    
    func didDecode(_ decodedPacket:SocketDownstreamPacket)
}
