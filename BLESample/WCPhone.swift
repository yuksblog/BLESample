//
//  WCPhone.swift
//  BLESample
//
//  Created by 今井幸宣 on 2020/07/12.
//  Copyright © 2020 yukinobu.imai. All rights reserved.
//

import Foundation

import WatchConnectivity


class WCPhone: NSObject, WCSessionDelegate {
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        } else {
        }
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith state= \(activationState.rawValue)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("didReceiveMessage: \(message)")
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print("didReceiveUserInfo: \(userInfo)")
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        print("didReceive file \(file)")
    }
}

