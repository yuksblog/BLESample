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
    
    var characteristis: CBCharacteristic?
    
    
    // TODO スキャンのタイムアウト処理
    
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
        
        // TODO この時にスキャンは停止した方が良い？サンプルだと接続後
    }
    
    func write() {
        peripheral?.writeValue(Data(from: Double(1.5)), for: (self.service?.characteristics?.first)!, type: .withoutResponse)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        let name = peripheral.name
        let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String
        print("BLE discovered \(String(describing: name)) LocalName=\(String(describing: localName))")
        if localName != nil && localName == "Moselog" {
            candidateNames.append(localName!)
            candidates.append(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("BLE connected")
        peripheral.delegate = self
        peripheral.discoverServices([Const.SERVICE_UUID])
        
        // MEMO 複数のPeripheralと接続するのであれば、CBPeripheralDelegateは別のクラスにした方がわかりやすくなる
        // １つのPeripheralと接続するので、今回は１つのクラスにまとめた
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("BLE connect failed")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("BLE discovered services")
        peripheral.discoverCharacteristics([Const.CHARACTERISTIC_UUID], for: (peripheral.services?.first)!)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("BLE discovered characteristics")
        
        self.service = service
        // MEMO discoverできた後に、Characteristisにアクセスできるようになる
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("BLE updated characteristis: \(characteristic.value!)")
    }
    
}
