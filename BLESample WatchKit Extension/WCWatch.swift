//
//  WCWatch.swift
//  BLESample WatchKit Extension
//
//  Created by 今井幸宣 on 2020/07/12.
//  Copyright © 2020 yukinobu.imai. All rights reserved.
//

import Foundation
import WatchConnectivity

class WCWatch: NSObject, ObservableObject, WCSessionDelegate {
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("sessionReachabilityDidChange: \(session.isReachable)")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith: \(activationState)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("didReceiveMessage: \(message)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("didReceiveMessage with replyHandler: \(message)")
        replyHandler(message)
    }
    
    func send(message: [String : Any]) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(message, replyHandler: nil) { error in
                print(error)
            }
        } else {
            WCSession.default.transferUserInfo(message)
        }
    }
    
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        print("finished file transfer \(fileTransfer) error=\(String(describing: error))")
    }
    
}
