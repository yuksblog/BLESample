//
//  MyPheripheral.swift
//  BLESample
//
//  Created by 今井幸宣 on 2020/07/12.
//  Copyright © 2020 yukinobu.imai. All rights reserved.
//

import UIKit
import CoreBluetooth

class MyPeripheral: NSObject, ObservableObject, CBPeripheralManagerDelegate {

    let peripheralManager = CBPeripheralManager()
    
    var service: CBMutableService?
    
    
    override init() {
        super.init()
        peripheralManager.delegate = self
    }
    
    func regist() {
        print("start regist")
        
        // create service
        service = CBMutableService(type: Const.SERVICE_UUID, primary: true)
        
        // create characteristic
        let characteristic = CBMutableCharacteristic(type: Const.CHARACTERISTIC_UUID, properties: [.read, .writeWithoutResponse], value: nil, permissions: [.readable, .writeable])
        service!.characteristics = [characteristic]
        
        // regist
        peripheralManager.add(service!)
    }
    
    func startAdvertise() {
        guard let service = service else {
            return
        }
        
        print("start Advertise")
        let advertisementData = [CBAdvertisementDataServiceUUIDsKey: [service.uuid], CBAdvertisementDataLocalNameKey: "Moselog"] as [String : Any]
        peripheralManager.startAdvertising(advertisementData)
    }
    
    func stopAdvertise() {
        print("stop Advertise")
        peripheralManager.stopAdvertising()
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
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        print("didAdd error=\(String(describing: error))")
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("peripheralManagerDidStartAdvertising error=\(String(describing: error))")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        let req = requests.first
        print("didReceiveWrite: \(req?.value?.to(type: Double.self))")
    }
    
}
