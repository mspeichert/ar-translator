//
//  BlobArea.swift
//  ar-translator
//
//  Created by Marek Kozłowski on 13/04/2018.
//  Copyright © 2018 Speichert&Kozlowski. All rights reserved.
//

import UIKit
class BlobArea : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }
   override func draw(_ rect: CGRect) {
    let xPos = rect.origin.x
    let yPos = rect.origin.y
    let yourWidth = rect.width
    let yourHeight = rect.height
  
    let myBezier = UIBezierPath()
    myBezier.move(to: CGPoint(x: xPos, y: yPos))
    myBezier.addLine(to: CGPoint(x: xPos, y: yPos))
    myBezier.addLine(to: CGPoint(x: xPos+yourWidth, y: yPos))
    myBezier.addLine(to: CGPoint(x: xPos+yourWidth, y: yPos+yourHeight))
    myBezier.addLine(to: CGPoint(x: xPos, y: yPos+yourHeight))

    myBezier.close()
    UIColor.black.setStroke()
    myBezier.stroke()
    }
}
