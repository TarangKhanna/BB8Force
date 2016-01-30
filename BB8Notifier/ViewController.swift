//
//  ViewController.swift
//  bb8Notifier
//
//  Created by Tarang khanna on 1/29/16.
//  Copyright © 2016 Tarang khanna. All rights reserved.
//

import UIKit
import WatchConnectivity
import CoreMotion

@available(iOS 9.0, *)
class ViewController: UIViewController , WCSessionDelegate {
    
    var session: WCSession!
    var robot: RKConvenienceRobot!
    var ledON = false
    
    let motionManager = CMMotionManager()
    
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet var connectionLabel: UILabel!
    
    override func viewDidLoad() {
        motionManager.gyroUpdateInterval = 0.6
        let handler:CMGyroHandler = {(data: CMGyroData?, error: NSError?) -> Void in
            print("x: \(data!.rotationRate.x)")
            print("y: \(data!.rotationRate.y)")
            print("z: \(data!.rotationRate.z)")
            let x = data!.rotationRate.x
            let y = data!.rotationRate.y
            if(abs(Double(x)) > abs(Double(y))) {
                if(Double(x) > 0.3) {
                    //                        self.connectionLabel.text = "Go X"
                    if let robot = self.robot {
                        print("moving")
                        self.robot.sendCommand(RKRollCommand(heading: 360, andVelocity: (Float(50.0)))) // acceleration -1 to 1
                        
                        //                            sleep(1)
//                        self.robot.sendCommand(RKRollCommand(heading: 360, andVelocity: 0))
                    }
                } else if(Double(x) < -0.3){
                    //                        self.connectionLabel.text = "Go X"
                    
                    if let robot = self.robot {
                        print("moving")
                        self.robot.sendCommand(RKRollCommand(heading: 0, andVelocity: (Float(50.0))))
                        
                        //                            sleep(1)
//                        self.robot.sendCommand(RKRollCommand(heading: 0, andVelocity: 0))
                    }
                }
            } else {
                if(Double(y) > 0.3) {
                    //                        self.connectionLabel.text = "Go Y"
                    if let robot = self.robot {
                        print("moving")
                        self.robot.sendCommand(RKRollCommand(heading: 90, andVelocity: (Float(50.0)))) // acceleration -1 to 1
                        
                        //                            sleep(1)
//                        self.robot.sendCommand(RKRollCommand(heading: 90, andVelocity: 0))
                    }
                } else if(Double(y) < -0.3){
                    //                        self.connectionLabel.text = "Go Y"
                    if let robot = self.robot {
                        print("moving")
                        self.robot.sendCommand(RKRollCommand(heading: 270, andVelocity: (Float(50.0))))
                        
                        //                            sleep(1)
//                        self.robot.sendCommand(RKRollCommand(heading: 270, andVelocity: 0))
                    }
                }
            }
            
        }
        motionManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: handler)
        
        super.viewDidLoad()
        
        //        if (motionManager.accelerometerAvailable == true) {
        //            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: { (data, error) -> Void in
        //                guard let data = data else { return }
        ////                sleep(3)
        //                let x = data.acceleration.x
        ////                print("x = \(x)")
        //                let y = data.acceleration.y
        ////                print("y = \(y)")
        //                let accelerationZ = data.acceleration.z
        ////                print("z = \(accelerationZ)")
        //                if(abs(Double(x)) > abs(Double(y))) {
        //                    if(Double(x) > 0) {
        ////                        self.connectionLabel.text = "Go X"
        //                        if let robot = self.robot {
        //                            print("moving")
        //                            self.robot.sendCommand(RKRollCommand(heading: 360, andVelocity: (Float(50.0*x)))) // acceleration -1 to 1
        //
        ////                            sleep(1)
        //                            self.robot.sendCommand(RKRollCommand(heading: 360, andVelocity: 0))
        //                        }
        //                    } else {
        ////                        self.connectionLabel.text = "Go X"
        //
        //                        if let robot = self.robot {
        //                            print("moving")
        //                            self.robot.sendCommand(RKRollCommand(heading: 0, andVelocity: (Float(50.0*x))))
        //
        ////                            sleep(1)
        //                            self.robot.sendCommand(RKRollCommand(heading: 0, andVelocity: 0))
        //                        }
        //                    }
        //                } else {
        //                    if(Double(y) > 0) {
        ////                        self.connectionLabel.text = "Go Y"
        //                        if let robot = self.robot {
        //                            print("moving")
        //                            self.robot.sendCommand(RKRollCommand(heading: 90, andVelocity: (Float(50.0*y)))) // acceleration -1 to 1
        //
        ////                            sleep(1)
        //                            self.robot.sendCommand(RKRollCommand(heading: 90, andVelocity: 0))
        //                        }
        //                    } else {
        ////                        self.connectionLabel.text = "Go Y"
        //                        if let robot = self.robot {
        //                            print("moving")
        //                            self.robot.sendCommand(RKRollCommand(heading: 270, andVelocity: (Float(50.0*y))))
        //
        ////                            sleep(1)
        //                            self.robot.sendCommand(RKRollCommand(heading: 270, andVelocity: 0))
        //                        }
        //                    }
        //                }
        //
        //            })
        
        
        //        }
        
        
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appWillResignActive:", name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appDidBecomeActive:", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        RKRobotDiscoveryAgent.sharedAgent().addNotificationObserver(self, selector: "handleRobotStateChangeNotification:")
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        //handle received message
        let value = message["Acceleration"] as? String
        outputLabel.text = value
        var array = value?.componentsSeparatedByString(" ")
        print(array)
        let x = array![0]
        let y = array![1]
        //            self.messageLabel.text = value
        if(abs(Double(x)!) > abs(Double(y)!)) {
            if(Double(x) > 0) {
                //                        self.connectionLabel.text = "Go X"
                if let robot = self.robot {
                    print("moving")
                    self.robot.sendCommand(RKRollCommand(heading: 360, andVelocity: 50.0)) // acceleration -1 to 1
                    
                    //                    sleep(1)
//                    self.robot.sendCommand(RKRollCommand(heading: 360, andVelocity: 0))
                }
            } else {
                //                        self.connectionLabel.text = "Go X"
                
                if let robot = self.robot {
                    print("moving")
                    self.robot.sendCommand(RKRollCommand(heading: 0, andVelocity: 50.0))
                    
                    //                    sleep(1)
//                    self.robot.sendCommand(RKRollCommand(heading: 0, andVelocity: 0))
                }
            }
        } else {
            if(Double(y) > 0) {
                //                        self.connectionLabel.text = "Go Y"
                if let robot = self.robot {
                    print("moving")
                    self.robot.sendCommand(RKRollCommand(heading: 90, andVelocity: 50.0)) // acceleration -1 to 1
                    
                    //                    sleep(1)
//                    self.robot.sendCommand(RKRollCommand(heading: 90, andVelocity: 0))
                }
            } else {
                //                        self.connectionLabel.text = "Go Y"
                if let robot = self.robot {
                    print("moving")
                    self.robot.sendCommand(RKRollCommand(heading: 270, andVelocity: 50.0))
                    
                    //                    sleep(1)
//                    self.robot.sendCommand(RKRollCommand(heading: 270, andVelocity: 0))
                }
            }
        }
        
        //send a reply
        //        replyHandler(["Value":"Hello Watch"])
    }
    
    
    @IBAction func testStop(sender: AnyObject) {
        robot.sendCommand(RKRollCommand(stopAtHeading: 0))
    }
    
    
    @IBAction func testMove(sender: AnyObject) {
        print("move")
        if let robot = robot {
            robot.sendCommand(RKRollCommand(heading: 0, andVelocity: 50.0))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        connectionLabel = nil;
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    @IBAction func sleepButtonTapped(sender: AnyObject) {
        if let robot = self.robot {
            connectionLabel.text = "Sleeping"
            robot.sleep()
        }
    }
    
    func appWillResignActive(note: NSNotification) {
        RKRobotDiscoveryAgent.disconnectAll()
        stopDiscovery()
    }
    
    func appDidBecomeActive(note: NSNotification) {
        startDiscovery()
    }
    
    func handleRobotStateChangeNotification(notification: RKRobotChangedStateNotification) {
        let noteRobot = notification.robot
        
        switch (notification.type) {
        case .Connecting:
            connectionLabel.text = "\(notification.robot.name()) Connecting"
            break
        case .Online:
            let conveniencerobot = RKConvenienceRobot(robot: noteRobot);
            
            if (UIApplication.sharedApplication().applicationState != .Active) {
                conveniencerobot.disconnect()
            } else {
                self.robot = RKConvenienceRobot(robot: noteRobot);
                
                connectionLabel.text = noteRobot.name()
                //                togleLED()
            }
            break
        case .Disconnected:
            connectionLabel.text = "Disconnected"
            startDiscovery()
            robot = nil;
            
            break
        default:
            NSLog("State change with state: \(notification.type)")
        }
    }
    
    func startDiscovery() {
        connectionLabel.text = "Discovering Robots"
        RKRobotDiscoveryAgent.startDiscovery()
    }
    
    func stopDiscovery() {
        RKRobotDiscoveryAgent.stopDiscovery()
    }
    
    //    func togleLED() {
    //        if let robot = self.robot {
    //            if (ledON) {
    //                robot.setLEDWithRed(0.0, green: 0.0, blue: 0.0)
    //            } else {
    //                robot.setLEDWithRed(0.0, green: 0.0, blue: 1.0)
    //            }
    //            ledON = !ledON
    //
    //            var delay = Int64(0.5 * Float(NSEC_PER_SEC))
    //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay), dispatch_get_main_queue(), { () -> Void in
    //                self.togleLED();
    //            })
    //        }
    //    }
}

