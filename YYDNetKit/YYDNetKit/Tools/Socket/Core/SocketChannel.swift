//
//  SocketChannel.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/25.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

public protocol SocketChannelDelegate:AnyObject {
    
    func channel(_ channel:SocketChannel, open onHost:String, port:UInt16)
    func channel(_ channel:SocketChannel, close error:Error?)
    
    func channel(_ channel:SocketChannel, received packet:SocketDownstreamPacket)
}

public class SocketChannel: SocketConnection {
    
    public var encoder:SocketEncoderProtocol?
    public var decoder:SocketDecoderProtocol?
    
    fileprivate var delegates = MulticastDelegate<SocketChannelDelegate>()
    
    // auto reconnect
    fileprivate var connectTimer:Timer? = nil
    fileprivate var connectCount:Int = 0
    fileprivate var connectTimerInterval:TimeInterval = 5.0
    fileprivate let connectMaxCount:Int = 1000
    
    fileprivate var receiveDataBuffer:Data = Data()
    fileprivate var downstreamContext:SocketPacketResponse = SocketPacketResponse()
    
    public init(connectParam:SocketConnectParam) {
        super.init(withParam: connectParam)
    }
    
    
    public func addDelegate(_ delegate:SocketChannelDelegate) -> Void {
        
        self.delegates += delegate
    }
    
    public func removeDelegate(_ delegate:SocketChannelDelegate) -> Void {
        
        self.delegates -= delegate
    }
    
    public func openConnection() {
        
        if self.isConnected {
            return
        }
        
        self.closeConnection()
        self.connect()
    }
    
    public func closeConnection() {
        
        self.disconnect()
        
        self.stopConnectTimer()
        
        self.stopHeartbeatTimer()
    }
    
    public func asyncSendPacket(_ packet:SocketUpstreamPacket) {
        
        self.dispatchOnSocketQueue(withClosure: { [weak self] in
            
            guard let strongself = self else {return}
            
            strongself.encoder?.encode(packet, output: strongself)
            
        }, isAsync: true)
    }
    
    fileprivate func stopConnectTimer() {
        
        if let timer = self.connectTimer {
            timer.invalidate()
            self.connectTimer = nil
        }
    }
    
    func startConnectTimer(_ interval:TimeInterval) {
        
        let minInterval = max(5, interval)
        
        self.stopHeartbeatTimer()
        
        self.connectTimer = Timer.scheduledTimer(timeInterval: minInterval, target: self, selector: #selector(SocketChannel.connectTimerFunction), userInfo: nil, repeats: false)
    }
    
    @objc fileprivate func connectTimerFunction() {
    
        if !self.connectParam.autoReconnect {
            self.stopConnectTimer()
            return
        }
        
        if self.connectCount > connectMaxCount {
            self.stopConnectTimer()
            return
        }
        
        self.connectCount += 1
        
        if self.connectCount % 10 == 0 {
            self.connectTimerInterval += 5
            self.startConnectTimer(self.connectTimerInterval)
        }
        
        if self.isConnected {
            return
        }
        
        self.openConnection()
    }
    
    // MARK: - channel
    override func didConnect(toHost host: String, port: UInt16) {
        
        self.connectCount = 0
        self.connectTimerInterval = 5.0
        
        if self.connectParam.heartbeatEnabled {
            
            DispatchQueue.main.async {
                self.stopConnectTimer()
                self.startHeartbeatTimer(self.connectParam.heartbeatInterval)
            }
        }
        
        DispatchQueue.main.async {
            self.delegates |> { delegate in
                
                delegate.channel(self, open: host, port: port)
            }
        }
        
        self.read(withTimeout: -1, tag: 0)
    }
    
    override func didDisconnect(withError error: Error?) {
        
        DispatchQueue.main.async {
            self.delegates |> { delegate in
                
                delegate.channel(self, close: error)
            }
        }
        
        if self.connectParam.autoReconnect {
            
            DispatchQueue.main.async {
                self.startConnectTimer(self.connectTimerInterval)
            }
        }
    }
    
    override func didRead(withData data: Data, tag: Int) {
        
        print("did read data \(data.count)")
        
        guard data.count > 0 else {
            return
        }
        
        synchronized(lock: self) {
            
            receiveDataBuffer.append(data)
            
            downstreamContext.object = receiveDataBuffer
            
            guard let decoder = self.decoder else {return}
            let decodedLength = decoder.decode(&downstreamContext, output: self)
            
            if decodedLength < 0 {
                print("decode faile")
                self.closeConnection()
                return
            }
            
            if decodedLength > 0 {
                let range = decodedLength...
                let remainData = receiveDataBuffer.subdata(in: range)
                receiveDataBuffer = remainData
            }
            print("receive data buffer length \(receiveDataBuffer.count)")
        }
    }
    
    override func didReceived(_ packet: SocketDownstreamPacket) {
        
        DispatchQueue.main.async {
            self.delegates |> { delegate in
                
                delegate.channel(self, received: packet)
            }
        }
    }
}

extension SocketChannel: SocketEncoderOutputProtocol {
    
    public func didEncode(_ encodeData: Data?, timeout: TimeInterval) {
        guard let encodeData = encodeData, encodeData.count > 0 else {
            return
        }
        
        self.write(data: encodeData, timeout: timeout, tag: 0)
    }
}

extension SocketChannel: SocketDecoderOutputProtocol {
    
    public func didDecode(_ decodedPacket: SocketDownstreamPacket) {
        
        self.didReceived(decodedPacket)
    }
}
