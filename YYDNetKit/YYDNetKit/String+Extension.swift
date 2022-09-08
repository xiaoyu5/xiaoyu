//
//  String+Extension.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/27.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

extension String {
    
    func jsonDict() -> [String:Any]? {
        
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        
        do {
            if let obj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] {
                return obj
            }else {
                return nil
            }
        } catch {
            print("data to dictionary error")
            return nil
        }
    }
}
