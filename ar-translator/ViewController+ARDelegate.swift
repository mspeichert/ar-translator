//
//  ViewController+ARDelegate.swift
//  ar-translator
//
//  Created by Mikolaj on 11/04/2018.
//  Copyright © 2018 Speichert&Kozlowski. All rights reserved.
//

import ARKit

extension ViewController: ARSKViewDelegate,  ARSessionDelegate {
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        
        switch camera.trackingState {
        case .limited(.initializing):
            print("Camera starting up")
        case .notAvailable:
            print("Not available")
        case .normal:
            print("Camera in normal state")
        default:
            break
        }
    }
}
