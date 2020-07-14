//
//  MyPeripheral.swift
//  BLESample WatchKit Extension
//
//  Created by 今井幸宣 on 2020/07/12.
//  Copyright © 2020 yukinobu.imai. All rights reserved.
//

import UIKit
import CoreBluetooth

class MyPeripheral: NSObject, CBPeripheralManagerDelegate {

    let peripheralManager = CBPeripheralManager()
    
    
    
    override init() {
        super.init()
        peripheralManager.delegate = self
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOff:
            print("Bluetooth PoweredOff")
            break
        case .poweredOn:
            print("Bluetooth poweredOn")
            break
        case .resetting:
            print("Bluetooth resetting")
            break
        case .unauthorized:
            print("Bluetooth unauthorized")
            break
        case .unknown:
            print("Bluetooth unknown")
            break
        case .unsupported:
            print("Bluetooth unsupported")
            break
        @unknown default:
            print("Bluetooth illegalstate \(peripheral.state)")
        }
    }
    
    func register() {
        
        // create service
        let service = CBService(
        
    }
    
}
