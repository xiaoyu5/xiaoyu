//
//  SocketChannelProxy.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/29.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

public class SocketChannelProxy {
    
    // MARK: - single
    public static let share:SocketChannelProxy = SocketChannelProxy()
    
    public var encoder:SocketEncoderProtocol?
    public var decoder:SocketDecoderProtocol?
    
    public var callReplyManager:SocketCallReplyManager
    
    fileprivate var channel:SocketChannel?
    
    public var connectCallReply:ConnectCallReply?
    
    public func asyncConnect(_ connectCallReply:ConnectCallReply) {
        
        self.connectCallReply = connectCallReply
        
        self.openConnection()
    }
    
    public func disconnect() {
        
        self.closeConnection()
    }
    
    public func asyncCallReply(_ callReply:SocketCallReply) {
    
        
    }
    
    public func asyncNotify(_ callReply:SocketCallReply) {
        
        
    }
    
    init() {
        self.callReplyManager = SocketCallReplyManager()
    }
}

extension SocketChannelProxy {
    
    public func openConnection() {
        
        self.closeConnection()
        
        if let connectCallReply = self.connectCallReply {
            let connectParam = SocketConnectParam.init(connectCallReply.host, port: connectCallReply.port)
            
            self.channel = SocketChannel.init(connectParam: connectParam)
            self.channel?.encoder = self.encoder
            self.channel?.decoder = self.decoder
            self.channel?.addDelegate(self)
            
            self.channel?.openConnection()
        }
    }
    
    public func closeConnection() {
        
        if let channel = self.channel {
            channel.closeConnection()
            channel.removeDelegate(self)
            self.channel = nil
        }
    }
}

extension SocketChannelProxy:SocketChannelDelegate {
    
    public func channel(_ channel: SocketChannel, open onHost: String, port: UInt16) {
        
        if let connectCallReply = self.connectCallReply {
            connectCallReply.onSuccess(connectCallReply, response: nil)
        }
    }
    
    public func channel(_ channel: SocketChannel, close error: Error?) {
        
        if let connectCallReply = self.connectCallReply {
            connectCallReply.onFailure(connectCallReply, error: error)
        }
    }
    
    public func channel(_ channel: SocketChannel, received packet: SocketDownstreamPacket) {
        
        
    }
}
