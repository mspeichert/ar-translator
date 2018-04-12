//
//  ViewController.swift
//  ar-translator
//
//  Created by Mikolaj Speichert on 31/03/2018.
//  Copyright © 2018 Speichert&Kozlowski. All rights reserved.
//

import UIKit
import ARKit
import SpriteKit
import SwiftOCR
import CoreMotion

class ViewController: UIViewController {
    @IBOutlet weak var Scene: ARSCNView!
    let OCRInstance = SwiftOCR()
    var orientationManager: OrientationManager?
    
    @IBAction func onSnapPressed(_ sender: Any) {
        let rotation = self.orientationManager?.rotation
        
        guard rotation != nil else {
            return
        }
        
        let image = Scene.snapshot().rotate(radians: -rotation!)!
        OCRInstance.performCCL(image){ sizes in
            print(sizes)
        }
        
        OCRInstance.recognize(image){ result in
            print(result)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Scene.delegate = self
        orientationManager = OrientationManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        Scene.session.run(sceneViewConfig)
        print(Scene.scene.rootNode.childNodes)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        Scene.session.pause()
    }
    
    var sceneViewConfig: ARWorldTrackingConfiguration = {
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        return configuration
    }()
}
