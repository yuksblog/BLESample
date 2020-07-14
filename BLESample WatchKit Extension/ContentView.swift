//
//  ContentView.swift
//  BLESample WatchKit Extension
//
//  Created by 今井幸宣 on 2020/07/11.
//  Copyright © 2020 yukinobu.imai. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var central = MyCentral()
    
    var wc = WCWatch()
    
    
    var body: some View {
        ScrollView {
            VStack {
                Text("BLEセントラル")
                Text("スキャン")
                HStack {
                    Button(action: { self.central.startScan() }) { Text("開始") }
                    Button(action: { self.central.stopScan() }) { Text("停止") }
                }
                ForEach(0..<self.central.candidateNames.count, id: \.self) { i in
                    Text(self.central.candidateNames[i]).onTapGesture {
                        self.central.connect(index: i)
                    }
                }
                Button(action: { self.central.write() }) { Text("通知") }
                Button(action: { self.wc.send(message: ["Hello" : "World"]) }) { Text("WC通知") }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
