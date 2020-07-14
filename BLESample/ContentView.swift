//
//  ContentView.swift
//  BLESample
//
//  Created by 今井幸宣 on 2020/07/11.
//  Copyright © 2020 yukinobu.imai. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var peripheral = MyPeripheral()
    
    var wc = WCPhone()
    
    var body: some View {
        VStack(spacing: 50) {
            Text("BLEペリフェラル")
            HStack(spacing: 20) {
                Text("レジスト")
                Button(action: { self.peripheral.regist() }) { Text("スタート") }
            }
            HStack(spacing: 20) {
                Text("アドバタイズ")
                Button(action: { self.peripheral.startAdvertise() }) { Text("スタート") }
                Button(action: { self.peripheral.stopAdvertise() }) { Text("ストップ") }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
