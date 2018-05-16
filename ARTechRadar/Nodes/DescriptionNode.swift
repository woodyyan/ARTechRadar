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
    override init() {
        super.init()
        let box = SCNBox(width: 0.2, height: 0.3, length: 0.003, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.8)
        
        self.geometry = box
        self.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: SCNPhysicsShape(geometry: box, options: nil))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
