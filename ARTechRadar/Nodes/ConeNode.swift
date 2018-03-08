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

class ConeNode: SCNNode {
    let bottomRadius: Float = 0.01
    let height: Float = 0.02
    init(_ color:UIColor) {
        super.init()
        let cone = SCNCone(topRadius: 0, bottomRadius: CGFloat(bottomRadius), height: CGFloat(height))
        cone.firstMaterial?.diffuse.contents = color
        
        self.geometry = cone
        self.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: SCNPhysicsShape(geometry: cone, options: nil))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
