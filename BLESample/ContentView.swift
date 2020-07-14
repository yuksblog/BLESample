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
    
    var body: some View {
        VStack(spacing: 50) {
            HStack(spacing: 20) {
                Text("アドバタイズ")
                Button(action: { self.peripheral.startRegistAndAdvertise() }) { Text("スタート") }
                Button(action: { self.peripheral.stopAdvertise() }) { Text("ストップ") }
            }
            HStack(spacing: 20) {
                Text("Centralからの書き込み")
                Text("\(self.peripheral.wroteMessage)")
            }
            HStack(spacing: 20) {
                Text("Centralへ通知")
                Button(action: { self.peripheral.notify() }) { Text("通知") }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
