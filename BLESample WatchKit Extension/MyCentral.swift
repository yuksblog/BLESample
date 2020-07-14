//
//  MyCentral.swift
//  BLESample
//
//  Created by 今井幸宣 on 2020/07/11.
//  Copyright © 2020 yukinobu.imai. All rights reserved.
//

import UIKit
import CoreBluetooth

class MyCentral: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    let centralManager = CBCentralManager()
    
    @Published var candidateNames: [String] = []
    
    var candidates: [CBPeripheral] = []
    
    var peripheral: CBPeripheral?
    
    var service: CBService?
    
    var writeCharacteristic: CBCharacteristic?

    var notifyCharacteristic: CBCharacteristic?

    var count: UInt32 = 0
    
    @Published var notifiedMessage = "未受信"
    
    
    
    override init() {
        super.init()
        centralManager.delegate = self
    }
    
    func startScan() {
        print("start scan")
        
        candidateNames.removeAll()
        candidates.removeAll()
        
        if !centralManager.isScanning {
            centralManager.scanForPeripherals(withServices: [Const.SERVICE_UUID], options: nil)
        }
    }
    
    func stopScan() {
        print("stop scan")
        if centralManager.isScanning {
            centralManager.stopScan()
        }
    }
    
    // Centralの状態が変化したとき
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("BLE PoweredOff")
            break
        case .poweredOn:
            print("BLE poweredOn")
            break
        case .resetting:
            print("BLE resetting")
            break
        case .unauthorized:
            print("BLE unauthorized")
            break
        case .unknown:
            print("BLE unknown")
            break
        case .unsupported:
            print("BLE unsupported")
            break
        @unknown default:
            print("BLE illegalstate \(central.state)")
        }
    }
    
    func connect(index: Int) {
        print("BLE start connect")
        self.peripheral = candidates[index]
        centralManager.connect(self.peripheral!, options: nil)
    }
    
    func write() {
        peripheral?.writeValue(Data(from: count), for: (self.service?.characteristics?.first)!, type: .withoutResponse)
        count += 1
    }
    
    // Peripheralを見つけたとき
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        let name = peripheral.name
        let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String
        print("BLE discovered \(String(describing: name)) LocalName=\(String(describing: localName))")
        if localName != nil && localName == "Moselog" {
            candidateNames.append(localName!)
            candidates.append(peripheral)
        }
    }
    
    // 接続したとき
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("BLE connected")
        peripheral.delegate = self
        peripheral.discoverServices([Const.SERVICE_UUID])
    }
    
    // 接続に失敗したとき
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("BLE connect failed")
    }
    
    // Serviceを見つけたとき
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("BLE discovered services")
        
        service = peripheral.services?.first
        
        peripheral.discoverCharacteristics([Const.WRITE_CHARACTERISTIC_UUID, Const.NOTIFY_CHARACTERISTIC_UUID], for: service!)
    }
    
    // Characteristicを見つけたとき
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("BLE discovered characteristics")
        
        for characteristic in service.characteristics! {
            
            if characteristic.uuid == Const.WRITE_CHARACTERISTIC_UUID {
                writeCharacteristic = characteristic
                
            } else if characteristic.uuid == Const.NOTIFY_CHARACTERISTIC_UUID {
                // 通知の受け取りを開始する
                notifyCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: notifyCharacteristic!)
            }
        }
    }
    
    // 通知を受け取ったとき
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("BLE updated characteristis: \(characteristic.value!)")
        let peripheralCount = characteristic.value!.withUnsafeBytes { $0.load( as: UInt32.self ) }
        notifiedMessage = "\(peripheralCount)"
    }
    
}
