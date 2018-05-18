//
//  DescriptionNode.swift
//  ARTechRadar
//
//  Created by Shuwen Li on 2018/5/16.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import SceneKit

class DescriptionNode: SCNNode {
    
    init(_ text: NSAttributedString) {
        super.init()
     
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        layer.backgroundColor = UIColor(white: 1, alpha: 0.7).cgColor
        
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: 40, y: 20, width: 320, height: 360)
        textLayer.string = text
        textLayer.alignmentMode = kCAAlignmentLeft
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.isWrapped = true
        textLayer.truncationMode = kCATruncationNone
        textLayer.display()
        layer.addSublayer(textLayer)
        
        let box = SCNBox(width: 0.4, height: 0.4, length: 0.003, chamferRadius: 0.2)
        box.firstMaterial?.locksAmbientWithDiffuse = true
        box.firstMaterial?.diffuse.contents = layer
        
        self.geometry = box
        self.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: SCNPhysicsShape(geometry: box, options: nil))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
