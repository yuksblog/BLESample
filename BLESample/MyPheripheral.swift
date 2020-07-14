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
    
//    var writeCharacteristic: CBMutableCharacteristic?
//    var notifyCharacteristic: CBMutableCharacteristic?

    let writeCharacteristic = CBMutableCharacteristic(type: Const.WRITE_CHARACTERISTIC_UUID, properties: [.read, .writeWithoutResponse], value: nil, permissions: [.readable, .writeable])
    
    let notifyCharacteristic = CBMutableCharacteristic(type: Const.NOTIFY_CHARACTERISTIC_UUID, properties: [.read, .notify], value: nil, permissions: [.readable, .writeable])

    @Published var wroteMessage = ""
    
    var count: UInt32 = 0
    
    
    
    override init() {
        super.init()
        peripheralManager.delegate = self
    }
    
    // アドバタイズ開始ボタンが押されたとき
    func startRegistAndAdvertise() {
        // まずはレジストから
        regist()
    }
    
    // アドバタイズ停止ボタンが押されたとき
    func stopAdvertise() {
        print("[BLE] stop Advertise")
        peripheralManager.stopAdvertising()
    }
    
    func notify() {
//        notifyCharacteristic?.value?.append(Data(from: Double(1.5))
        peripheralManager.updateValue(Data(from: count), for: notifyCharacteristic, onSubscribedCentrals: nil)
        count += 1
    }
    
    // レジスト
    func regist() {
        print("[BLE] start regist")
        
        // create service
        service = CBMutableService(type: Const.SERVICE_UUID, primary: true)
        
//        // create characteristic
//        let writeCharacteristic = CBMutableCharacteristic(type: Const.WRITE_CHARACTERISTIC_UUID, properties: [.read, .writeWithoutResponse], value: nil, permissions: [.readable, .writeable])
//        let notifyCharacteristic = CBMutableCharacteristic(type: Const.NOTIFY_CHARACTERISTIC_UUID, properties: [.read, .notify], value: nil, permissions: [.readable, .writeable])
        service!.characteristics = [writeCharacteristic, notifyCharacteristic]
        
        // regist
        peripheralManager.add(service!)
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
        print("didAdd error=\(String(describing: error))")
        
        // アドバタイズを開始
        let advertisementData = [CBAdvertisementDataServiceUUIDsKey: [service.uuid], CBAdvertisementDataLocalNameKey: "Moselog"] as [String : Any]
        peripheralManager.startAdvertising(advertisementData)
    }
    
    // アドバタイズが開始されたとき
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("peripheralManagerDidStartAdvertising error=\(String(describing: error))")
    }
    
    // Centralからの購読を受信したとき
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("didSubscribeTo: \(characteristic.isNotifying)")
    }
    // Centralからの書き込みを受信したとき
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("didReceiveWrite")
        
        let req = requests.first
        let centralCount = req!.value!.withUnsafeBytes { $0.load( as: UInt32.self ) }
        wroteMessage = "\(centralCount)"
    }
    
}
