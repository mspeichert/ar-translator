//
//  ViewController+determineOrientation.swift
//  ar-translator
//
//  Created by Mikolaj on 12/04/2018.
//  Copyright © 2018 Speichert&Kozlowski. All rights reserved.
//

import Foundation
import CoreMotion

class OrientationManager {
    
    let UPDATE_INTERVAL = 0.3
    var manager: CMMotionManager?
    var rotation: Double?
    
    init() {
        manager = CMMotionManager()
        let queue = OperationQueue()
        guard let manager = manager else {
            return
        }
        if manager.isGyroAvailable {
            if manager.isDeviceMotionAvailable {
                manager.deviceMotionUpdateInterval = UPDATE_INTERVAL
                manager.startDeviceMotionUpdates(to: queue) {
                    [weak self] (data: CMDeviceMotion?, error: Error?) in
                    if let gravity = data?.gravity {
                        self?.rotation = atan2(gravity.x, gravity.y) - Double.pi
//                        print(self?.rotation)
                    }
                }
            }
        }
    }
}
