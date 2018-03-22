//
//  SphereNode.swift
//  ARTechRadar
//
//  Created by Shuwen Li on 22/03/2018.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class SphereNode: SCNNode {
    let bottomRadius: Float = 0.02
    init(_ color:UIColor) {
        super.init()
        let sphere = SCNSphere.init(radius: CGFloat(bottomRadius))
        sphere.firstMaterial?.diffuse.contents = color
        
        self.geometry = sphere
        self.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: SCNPhysicsShape(geometry: sphere, options: nil))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
