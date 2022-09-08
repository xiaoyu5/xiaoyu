//
//  Data+Extension.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/27.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

extension Data {
    
    func jsonDict() -> [String:Any]? {
        
        do {
            if let obj = try JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String:Any] {
                return obj
            }else {
                return nil
            }
        } catch {
            print("data to dictionary error")
            return nil
        }
    }
    
    public func subdata(in range: CountableClosedRange<Data.Index>) -> Data {
        return self.subdata(in: range.lowerBound..<range.upperBound + 1)
    }
    
    public func subdata(in range: CountablePartialRangeFrom<Data.Index>) -> Data {
        return self.subdata(in: range.lowerBound..<self.count)
    }
}
