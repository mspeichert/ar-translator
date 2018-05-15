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
import ROGoogleTranslate
import CoreMotion
import DotEnv
struct Field {
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
}

class ViewController: UIViewController {
    
    let SCREEN_RATIO: CGFloat = 1.9625
    var field: Field?
    
    @IBOutlet weak var Scene: ARSCNView!
    
    @IBOutlet weak var highlightersView: UIView!
    
    @IBOutlet weak var actionButton: UIButton!
    let OCRInstance = SwiftOCR()
    var isInFindMode = true
    var timer = Timer()
    var orientationManager: OrientationManager?
    var recognizedWord: String = ""
    
    func radians (fromDegrees degrees: Double) -> Double { return degrees*Double.pi/180 }
    func degrees (fromRadians radians: Double) -> Double { return radians*180/Double.pi }
    
    @IBAction func onTranslate(_ sender: Any) {
        if(isInFindMode){
            let env = DotEnv(withFile: "data.env")
            while let subview = highlightersView.subviews.last {
                subview.removeFromSuperview()
            }
            self.isInFindMode = false

            self.actionButton.setTitle("Try again", for: UIControlState.normal)
            self.timer.invalidate()
           
            
            let params = ROGoogleTranslateParams(source: "pl",
                                                    target: "en",
                                                    text:   recognizedWord)
            let key = env.get("API_KEY") ?? "API-KEY-NOT-FOUND"
                    
            let translator = ROGoogleTranslate()
            translator.apiKey = key
                    
            translator.translate(params: params, callback: { (toPrint) in

                print("Translation: \(toPrint)")
                if let field = self.field {
                    DispatchQueue.main.async {
                        while let subview = self.highlightersView.subviews.last {
                            subview.removeFromSuperview()
                        }
                        let label = UILabel(frame: CGRect(x: field.x,
                                                            y: field.y,
                                                            width: field.width,
                                                            height: field.height))
                        label.text = toPrint
                        label.font = UIFont(name: "Courier new", size: field.height)
                        label.textAlignment = NSTextAlignment.center
                        label.textColor = UIColor.black
                        label.backgroundColor = UIColor.white
                        self.highlightersView.addSubview(label)
                    }
                }
            })
        }else{
            while let subview = self.highlightersView.subviews.last {
                subview.removeFromSuperview()
            }
            actionButton.setTitle("Translate", for: UIControlState.normal)
            isInFindMode = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.findLetters), userInfo: nil, repeats: true)
        }
    }

    @objc func findLetters(){
        
        if let image = determineImage() {
            OCRInstance.recognizeWithCCLEffects(image, { sizes in
                if(self.isInFindMode){
                    print(sizes.count)
                    DispatchQueue.main.async {
                        while let subview = self.highlightersView.subviews.last {
                            subview.removeFromSuperview()
                        }
                    }
                    if(sizes.count == 0) { return }
                    self.field = Field(x: sizes[0].origin.x/self.SCREEN_RATIO,
                                       y: sizes[0].origin.y/self.SCREEN_RATIO,
                                       width: ((sizes[sizes.count - 1].origin.x + sizes[sizes.count - 1].size.width) - sizes[0].origin.x)/self.SCREEN_RATIO,
                                       height: ((sizes[sizes.count - 1].origin.y + sizes[sizes.count - 1].size.height) - sizes[0].origin.y)/self.SCREEN_RATIO)
                    for blob in sizes{
                        let view = BlobArea(frame: CGRect(x: blob.origin.x/self.SCREEN_RATIO,
                                                          y: ( blob.origin.y)/self.SCREEN_RATIO,
                                                          width: blob.size.width/self.SCREEN_RATIO,
                                                          height: blob.size.height/self.SCREEN_RATIO))
                        view.backgroundColor = UIColor.clear
                        DispatchQueue.main.async {
                            self.highlightersView.addSubview(view)
                            view.setNeedsDisplay()
                        }
                    }
                }
            }, { result in
                print(result)
                self.recognizedWord = result
            })
        }
    }
    
    func determineImage() -> UIImage?{
        let rotation = self.orientationManager?.rotation
        
        guard rotation != nil else {
            return nil
        }
        return Scene.snapshot()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        highlightersView.backgroundColor = UIColor.clear
        Scene.delegate = self
        orientationManager = OrientationManager()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.findLetters), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Scene.session.run(sceneViewConfig)
        print(Scene.scene.rootNode.childNodes)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Scene.session.pause()
    }
    
    var sceneViewConfig: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        return configuration
    }()
}
