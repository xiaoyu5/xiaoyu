//
//  ViewController.swift
//  YYDNetKitDemo
//
//  Created by FG on 2018/1/25.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import UIKit
import YYDNetKit

class ViewController: UIViewController {

    lazy var socketChannel: SocketChannel = {
        let param = SocketConnectParam.init("120.24.242.163", port: 8002)
        
        var jsonEncode = SocketJSONEncoder.init()
        let yydEncode = SocketYYDEncoder.init()
        jsonEncode.nextEncoder = yydEncode
        
        var yydDecode = SocketYYDDecoder.init()
        yydDecode.nextDecoder = SocketJSONDecoder()
        
        let channel = SocketChannel.init(connectParam: param)
        var heartbeat = SocketPacketRequest()
        heartbeat.object = SocketYYDEncoder.beatData()
        channel.heartbeat = heartbeat
        channel.addDelegate(self)
        
        return channel
    }()
    
    @IBAction func connectClick(_ sender: Any) {
        
        self.socketChannel.openConnection()
    }
    
    @IBAction func sendBeat(_ sender: Any) {
        
        for _ in 0...9 {
            self.socketChannel.sendHeartbeat()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}


extension ViewController: SocketChannelDelegate {
    
    func channel(_ channel: SocketChannel, open onHost: String, port: UInt16) {
        
        print("channel open \(onHost):\(port)")
        
        var packet = SocketPacketRequest.init()
        packet.object = [
            "cmd":"/user/login",
            "id":"100602",
            "session":"WL3AEP7UINQCP8WL"
        ]
        
        
        self.socketChannel.asyncSendPacket(packet)
    }
    
    func channel(_ channel: SocketChannel, close error: Error?) {
        
        print("channel close \(String(describing: error))")
    }
    
    func channel(_ channel: SocketChannel, received packet: SocketDownstreamPacket) {
        
        print("receive packet \(String(describing: packet.object))")
    }
}
