//
//  InterfaceController.swift
//  BB8Force Extension
//
//  Created by Tarang khanna on 1/30/16.
//  Copyright © 2016 orbotix. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate{
    var session : WCSession!
    let motionManager = CMMotionManager()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        motionManager.accelerometerUpdateInterval = 0.1
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        super.willActivate()
        if (motionManager.accelerometerAvailable == true) {
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: { (data, error) -> Void in
                guard let data = data else { return }
                let accelerationX = data.acceleration.x
                print("x = \(accelerationX)")
                let accelerationY = data.acceleration.y
                print("y = \(accelerationY)")
                let accelerationZ = data.acceleration.z
                print("z = \(accelerationZ)")
//                let object = [accelerationX, accelerationY, accelerationZ]
                //                let dictionary = NSDictionary(dictionary: [object] as NSObject as! [NSObject : AnyObject])
                //                print(dictionary)
                // send)
                // cannot move in y
                var totalacc = String(accelerationX) + " " + String(accelerationY) + " " + String(accelerationZ)
                let messageToSend = ["Acceleration": totalacc]
                dispatch_async(dispatch_get_main_queue()) {
                    self.session.sendMessage(messageToSend, replyHandler: {(_: [String : AnyObject]) -> Void in
//                        print("here")
                        // handle reply from iPhone app here
                        }, errorHandler: {(error ) -> Void in
                            // catch any errors here
                            print(error)
                    })
                }
                
                
                
                //                sleep(1)
                // do you want to want to do with the data
            })
        }
        
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        //        let value = message["Value"] as? String
        
        dispatch_async(dispatch_get_main_queue()) {
            
        }
        
        //send a reply
        replyHandler(["Value":"Yes"])
        
    }
    
    
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
