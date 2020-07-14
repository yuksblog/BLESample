//
//  Const.swift
//  BLESample
//
//  Created by 今井幸宣 on 2020/07/11.
//  Copyright © 2020 yukinobu.imai. All rights reserved.
//

import Foundation
import CoreBluetooth

struct Const {
    static let SERVICE_UUID = CBUUID(string: "FCC6AD8D-A8EF-475F-B0FD-D106C00882FA")
    static let WRITE_CHARACTERISTIC_UUID = CBUUID(string: "B5D06B73-0B67-4861-B336-3386C2FF8A7B")
    static let NOTIFY_CHARACTERISTIC_UUID = CBUUID(string: "B5D06B73-0B67-4861-B336-3386C2FF8A7C")
}
