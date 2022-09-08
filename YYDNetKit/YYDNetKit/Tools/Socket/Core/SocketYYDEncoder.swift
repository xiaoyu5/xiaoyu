//
//  SocketYYDEncoder.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/26.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

public struct SocketYYDEncoder:SocketEncoderProtocol {
    
    public init() {
        
    }
    
    public func encode(_ packet: SocketUpstreamPacket, output: SocketEncoderOutputProtocol) {
        
        guard let data = packet.objData else {
            print("[Encode] object data is nil ...")
            return
        }
        
        let dataLength = data.count
        guard dataLength > 0 else {
            print("[Encode] object data is 0 ...")
            return
        }
        
        var sendData:Data = Data()
        
        // 判断是不是心跳数据
        let buffe = [UInt8](data.subdata(in: 0..<8))
        let zoCount = buffe.filter({ (byte) -> Bool in
            return byte == 0
        }).count
        if zoCount == 8 { // beat
            
            sendData = data
        }else { // other
            // append type
            sendData.append(SocketYYDEncoder.yydTypeData(1))
            // append len bytes
            var dataLenBytes = typetobinary(dataLength)
            let dataLenBytesSub = [UInt8](dataLenBytes[0...3].reversed())
            sendData.append(contentsOf: dataLenBytesSub)
            // append content
            sendData.append(data)
        }
        
        let timeout = packet.timeout
        print("timeout: \(timeout), sendData: \(sendData.count)")
        
        output.didEncode(sendData, timeout: timeout)
    }
    
    static func yydTypeData(_ type:Int) -> Data {
        var buff:[UInt8] = []
        // type
        let firstType = Array(String.init(format: "%c", type).utf8).first
        let otherType = Array(String.init(format: "%c", 0).utf8).first
        for i in 0..<8 {
            if i == 0 {
                buff.append(firstType!)
            }else {
                buff.append(otherType ?? 0)
            }
        }
        return Data.init(bytes: buff)
    }
    
    public static func beatData() -> Data {
        var buff:[UInt8] = []
        // type
        let firstType = Array(String.init(format: "%c", 0).utf8).first
        let otherType = Array(String.init(format: "%c", 0).utf8).first
        for i in 0..<8 {
            if i == 0 {
                buff.append(firstType ?? 0)
            }else {
                buff.append(otherType ?? 0)
            }
        }
        
        return Data(bytes: buff)
    }
}

enum BaseSocketDataError: Error {
    case jsonError
    case idOrSessionError
    case paramsError
}
