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
    
    var manager: CMMotionManager?
    var rotation: Float?
    
    init() {
        manager = CMMotionManager()
        let queue = OperationQueue()
        guard let manager = manager else {
            return
        }
        if manager.isGyroAvailable {
            if manager.isDeviceMotionAvailable {
                manager.deviceMotionUpdateInterval = 0.1
//                manager.startGyroUpdates(to: queue){
//                    (data, error) in print(data?.rotationRate)
//                }
                manager.startDeviceMotionUpdates(to: queue) {
                    [weak self] (data: CMDeviceMotion?, error: Error?) in
                    if let gravity = data?.gravity {
                        self?.rotation = Float(atan2(gravity.x, gravity.y) - Double.pi)
//                        print(self?.rotation)
                    }
                }
            }
        }
    }
}
