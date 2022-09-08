//
//  SocketYYDDecoder.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/26.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation


public struct SocketYYDDecoder:SocketDecoderProtocol {
    
    public var nextDecoder:SocketDecoderProtocol?
    
    public init() {
        
    }
    
    public func decode<T: SocketDownstreamPacket>(_ packet:inout T, output: SocketDecoderOutputProtocol) -> Int {
        
        let object = packet.object
        guard var downstreamData = object as? Data else {
            return -1
        }
        
        var headIndex:Int = 0
        
        decodeLoop:
        while downstreamData.count - headIndex > 0 {
            
            let typeData = downstreamData.subdata(in: 0..<1)
            let type = binarytotype([UInt8](typeData), String.UTF8View.Element.self)
            
            switch type {
            case UInt8(0): // 心跳
                print("receive beat")
                headIndex += 1
            case UInt8(1): // text
                // 4字节长度
                var lenBuff: [UInt8] = [UInt8]()
                for i in 0..<4 {
                    lenBuff.append(downstreamData[i+1])
                }
                let lenData = Data(bytes: lenBuff)
                // 包的总长度
                let frameLen = UInt32(bigEndian: lenData.withUnsafeBytes { $0.pointee })
                if frameLen > (1024*1024) { //数据乱流 清空缓存
                    print("数据异常，太大")
                    return -1
                }
                // 剩余数据，不是完整的数据包，则break继续读取等待
                if (downstreamData.count - headIndex) < (1+4 + frameLen) {
                    break decodeLoop
                }
                // 数据包(类型+长度＋内容)
                let frameData = downstreamData.subdata(in: headIndex..<Int(1+4 + frameLen))
                
                var packet = SocketPacketResponse()
                packet.object = frameData.subdata(in: 5..<Int(frameLen+5))
                
                if let nextDeocoder = nextDecoder {
                    _ = nextDeocoder.decode(&packet, output: output)
                }else {
                    output.didDecode(packet)
                }
                
                // 调整已经解码数据
                headIndex += frameData.count
                
            default:
                print("数据异常，未知类型")
                return -1
            }
        }
        
        return headIndex
    }
}
