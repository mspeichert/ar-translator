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
import ROGT

class ViewController: UIViewController {
    @IBOutlet weak var Scene: ARSCNView!
    @IBOutlet weak var blobsArea: UIImageView!
    @IBOutlet weak var blobsAreaView: BlobArea!
    let OCRInstance = SwiftOCR()
    var orientationManager: OrientationManager?
    
    var arrayOfBlobs = [CGRect]()
    @IBAction func onSnapPressed(_ sender: Any) {
        while let subview = blobsAreaView.subviews.last {
            subview.removeFromSuperview()
        }
        let rotation = self.orientationManager?.rotation
        
        guard rotation != nil else {
            return
        }
        
        let image = Scene.snapshot().rotate(radians: -rotation!)!
        OCRInstance.performCCL(image){ sizes in
            print(sizes)
            
            
            for blob in sizes{
                let view = BlobArea(frame: CGRect(x: blob.origin.x/1.9625, y: ( blob.origin.y)/1.9625, width: blob.size.width/1.9625, height: blob.size.height/1.9625))
                view.backgroundColor = UIColor.clear
                //To display frames
                DispatchQueue.main.async {
                    self.blobsAreaView.addSubview(view)
                    view.setNeedsDisplay()
                }
            }
        }
        
        OCRInstance.recognize(image){ result in
            print(result)
            
             let params = ROGoogleTranslateParams(source: "pl",
             target: "en",
             text:   result)
             //"AIzaSyA4dDdSmku8UOSePL5Nj_03YvC1IC14knI"
             let translator = ROGoogleTranslate()
             translator.apiKey = "Your-API-Key"
             
             translator.translate(params: params, callback: { (toPrint) in
             print("Translation: \(toPrint)")
             })
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blobsArea.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view, typically from a nib.
        blobsAreaView.backgroundColor = UIColor.clear
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
