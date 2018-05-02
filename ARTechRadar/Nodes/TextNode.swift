//
//  ConeNode.swift
//  ARTechRadar
//
//  Created by Shuwen Li on 08/03/2018.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class TextNode: SCNNode {
    let depth = 0.008
    init(_ text: String, _ color: UIColor) {
        super.init()
        let text = SCNText(string: text, extrusionDepth: CGFloat(depth))
        text.font = UIFont.init(name: "OpenSans-Regular", size: 4)
        text.firstMaterial?.diffuse.contents = color
        text.alignmentMode = kCAAlignmentCenter
        
        self.geometry = text
        self.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: SCNPhysicsShape(geometry: text, options: nil))
        self.scale = SCNVector3(0.01, 0.01, 0.01)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
