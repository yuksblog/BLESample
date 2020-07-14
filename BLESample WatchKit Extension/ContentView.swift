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
    
    var body: some View {
        ScrollView {
            VStack {
                Text("スキャン")
                HStack {
                    Button(action: { self.central.startScan() }) { Text("開始") }
                    Button(action: { self.central.stopScan() }) { Text("停止") }
                }
                Text("見つけたiPhone")
                ForEach(0..<self.central.candidateNames.count, id: \.self) { i in
                    Button(action: {
                        self.central.connect(index: i)
                    }) {
                        Text(self.central.candidateNames[i])
                    }
                }
                Text("メッセージ")
                Button(action: { self.central.write() }) { Text("書き込み") }
                Text("通知の受信: \(self.central.notifiedMessage)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
