//
//  YYDNetKitTests.swift
//  YYDNetKitTests
//
//  Created by FG on 2018/1/25.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import XCTest
import YYDNetKit

class YYDNetKitTests: XCTestCase {
    
    // 120.24.242.163 8002
    
    lazy var socketChannel: SocketChannel = {
        let param = SocketConnectParam.init("120.24.242.163", port: 8002)
        let channel = SocketChannel.init(connectParam: param)
        return channel
    }()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testSocket() {
        
        self.socketChannel.connect()
    }
}
