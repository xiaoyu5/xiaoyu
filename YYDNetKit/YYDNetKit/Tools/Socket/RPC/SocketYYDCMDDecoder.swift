//
//  SocketYYDCMDDecoder.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/29.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

public struct SocketYYDCMDDecoder:SocketDecoderProtocol {
    
    var nextDecoder:SocketDecoderProtocol?
    
    public init() {
        
    }
    
    public func decode<T>(_ packet: inout T, output: SocketDecoderOutputProtocol) -> Int where T : SocketDownstreamPacket {
        
        // 命令标识
        if let dictionary = packet.object as? [String:Any] {
            
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
                    packet.pid = "\(cmd)-\(commandCMD)"
                }else {
                    packet.pid = cmd
                }
            }
        }
        
        if let nextDeocoder = nextDecoder {
            return nextDeocoder.decode(&packet, output: output)
        }
        
        output.didDecode(packet)
        
        return 0
    }
}
