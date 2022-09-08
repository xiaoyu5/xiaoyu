//
//  CommonTool.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/26.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

// MARK: - synchronized
func synchronized(lock: AnyObject, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}

// MARK: - gcd after
public typealias Task = (_ cancel : Bool) -> Void
public func delay(_ time: TimeInterval, task: @escaping ()->()) ->  Task? {
    
    func dispatch_later(block: @escaping ()->()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    var closure: (()->Void)? = task
    var result: Task?
    
    let delayedClosure: Task = {
        cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    return result
}

public func cancel(_ task: Task?) {
    task?(true)
}

// MARK: - bytes type converter
/// input: array of bytes
/// -> get pointer to byte array (UnsafeBufferPointer<[Byte]>)
/// -> access its base address
/// -> rebind memory to target type T (UnsafeMutablePointer<T>)
/// -> extract and return the value of target type
public func binarytotype <T> (_ value: [UInt8], _: T.Type) -> T
{
    return value.withUnsafeBufferPointer {
        $0.baseAddress!
            .withMemoryRebound(to: T.self, capacity: 1) {
                $0.pointee
        }
    }
}

/// input type: value of type T
/// -> get pointer to value of T
/// -> rebind memory to the target type, which is a byte array
/// -> create array with a buffer pointer initialized with the     source pointer
/// -> return the resulted array
public func typetobinary <T> (_ value: T) -> [UInt8]
{
    var mv : T = value
    let s : Int = MemoryLayout<T>.size
    let point = withUnsafePointer(to: &mv) {
        $0.withMemoryRebound(to: UInt8.self, capacity: s) {
            Array(UnsafeBufferPointer(start: $0, count: s))
        }
    }
    return point
}
