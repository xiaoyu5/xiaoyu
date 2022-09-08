//
//  SocketYYDCMDEncoder.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/29.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

public struct SocketYYDCMDEncoder:SocketEncoderProtocol {
    
    public var nextEncoder:SocketEncoderProtocol?
    
    public init() {}
    
    public func encode(_ packet: SocketUpstreamPacket, output: SocketEncoderOutputProtocol) {
        
        var upstreamPacket = packet
        var dictionaryObject:[String:Any]? = nil
        var dataObject:Data? = nil
        
        switch upstreamPacket.object {
        case let data as Data:
            dataObject = data
            dictionaryObject = data.jsonDict()
        case let string as String:
            dataObject = string.jsonDict()?.jsonData()
            dictionaryObject = string.jsonDict()
        case let dictionary as [String:Any]:
            dataObject = dictionary.jsonData()
            dictionaryObject = dictionary
        default:
            print("[Decoder] object convert to dictionary error")
        }
        
        // 命令标识
        if let dictionary = dictionaryObject{
            
            if let cmd = dictionary["cmd"] as? String {
                
                let command = dictionary["command"]
                let commandDictOpt:[String:Any]?
                switch command {
                case let string as String:
                    commandDictOpt = string.jsonDict()
                case let dict as [String:Any]:
                    commandDictOpt = dict
                default:
                    commandDictOpt = nil
                    break
                }
                
                if let commandDict = commandDictOpt, let commandCMD = commandDict["cmd"] as? String {
                    upstreamPacket.pid = "\(cmd)-\(commandCMD)"
                }else {
                    upstreamPacket.pid = cmd
                }
            }
        }
        // 责任链模式
        if let nextEncoder = nextEncoder {
            upstreamPacket.object = dataObject
            nextEncoder.encode(upstreamPacket, output: output)
            return
        }
        
        output.didEncode(dataObject, timeout: upstreamPacket.timeout)
    }
}
