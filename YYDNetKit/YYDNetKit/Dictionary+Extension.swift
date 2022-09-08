//
//  Dictionary+Extension.swift
//  YYDNetKit
//
//  Created by FG on 2018/1/26.
//  Copyright © 2018年 yongyida. All rights reserved.
//

import Foundation

// MARK: - JSON
extension Dictionary {
    
    func jsonData() -> Data? {
        
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return data
        } catch {
            print("dictionary to data error")
            return nil
        }
    }
}
