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
    
    var writeCharacteristic: CBMutableCharacteristic?
    
    var notifyCharacteristic: CBMutableCharacteristic?
    
    @Published var wroteMessage = ""
    
    var count: UInt32 = 0
    
    
    
    override init() {
        super.init()
        peripheralManager.delegate = self
    }
    
    // アドバタイズ開始ボタンが押されたとき
    func startRegistAndAdvertise() {
        print("[BLE] start Regist and Advertise")
        
        // まずはレジストから
        regist()
    }
    
    // アドバタイズ停止ボタンが押されたとき
    func stopAdvertise() {
        print("[BLE] stop Advertise")
        
        peripheralManager.stopAdvertising()
    }
    
    func notify() {
        print("[BLE] notify")
        
        let data = Data(bytes: &count, count: MemoryLayout.size(ofValue: count))
        peripheralManager.updateValue(data, for: notifyCharacteristic!, onSubscribedCentrals: nil)
        count += 1
    }
    
    // レジスト
    func regist() {
        print("[BLE] start regist")
        
        // create service
        let service = CBMutableService(type: Const.SERVICE_UUID, primary: true)
        
        // create characteristic
        let writeCharacteristic = CBMutableCharacteristic(type: Const.WRITE_CHARACTERISTIC_UUID, properties: [.read, .writeWithoutResponse], value: nil, permissions: [.readable, .writeable])
        let notifyCharacteristic = CBMutableCharacteristic(type: Const.NOTIFY_CHARACTERISTIC_UUID, properties: [.read, .notify], value: nil, permissions: [.readable, .writeable])
        service.characteristics = [writeCharacteristic, notifyCharacteristic]
        
        // regist
        peripheralManager.add(service)
    }
    
    
    // PeripheralManagerの状態が変わったとき
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOff:
            print("[BLE]  PoweredOff")
            break
        case .poweredOn:
            print("[BLE]  poweredOn")
            break
        case .resetting:
            print("[BLE]  resetting")
            break
        case .unauthorized:
            print("[BLE]  unauthorized")
            break
        case .unknown:
            print("[BLE]  unknown")
            break
        case .unsupported:
            print("[BLE]  unsupported")
            break
        @unknown default:
            print("[BLE]  illegalstate \(peripheral.state)")
        }
    }
    
    // レジストが終わったとき
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        print("[BLE] didAdd error=\(String(describing: error))")
        
        // Service と Characteristicを持っておく
        self.service = service as? CBMutableService
        for characteristic in service.characteristics! {
            if characteristic.uuid == Const.NOTIFY_CHARACTERISTIC_UUID {
                notifyCharacteristic = characteristic as? CBMutableCharacteristic
            } else if characteristic.uuid == Const.WRITE_CHARACTERISTIC_UUID {
                writeCharacteristic = characteristic as? CBMutableCharacteristic
            }
        }
        
        // アドバタイズを開始
        let advertisementData = [CBAdvertisementDataServiceUUIDsKey: [service.uuid], CBAdvertisementDataLocalNameKey: "sample"] as [String : Any]
        peripheralManager.startAdvertising(advertisementData)
    }
    
    // アドバタイズが開始されたとき
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("[BLE] peripheralManagerDidStartAdvertising error=\(String(describing: error))")
    }
    
    // Centralからの購読を受信したとき
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("[BLE] didSubscribeTo")
    }
    
    // Centralからの書き込みを受信したとき
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("[BLE] didReceiveWrite")
        
        let req = requests.first
        let centralCount = req!.value!.withUnsafeBytes { $0.load( as: UInt32.self ) }
        wroteMessage = "\(centralCount)"
    }
    
}
