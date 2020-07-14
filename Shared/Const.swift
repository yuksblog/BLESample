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
    static let SERVICE_UUID = CBUUID(string: "6B5C4A86-CFB7-4031-98EB-09DF5E2543F0")
    static let WRITE_CHARACTERISTIC_UUID = CBUUID(string: "4551ABAE-CE14-4F9E-B31A-E61FC372E480")
    static let NOTIFY_CHARACTERISTIC_UUID = CBUUID(string: "DFB13451-1740-4F8A-B0F0-7C20D79E8BDF")
}
