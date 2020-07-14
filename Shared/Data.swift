//
//  Data.swift
//  BLESample
//
//  Created by 今井幸宣 on 2020/07/12.
//  Copyright © 2020 yukinobu.imai. All rights reserved.
//

import Foundation

extension Data {
    
    init<T>(from value: T) {
        var v = value
        self.init(buffer: UnsafeBufferPointer(start: &v, count: 1))
    }
    
    func to<T>(type: T.Type) -> T {
        return withUnsafeBytes { $0.pointee }
    }
}
