//
//  CylinderNode.swift
//  ARTechRadar
//
//  Created by Shuwen Li on 08/03/2018.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class CylinderNode: SCNNode {
    init(_ basicRadius: Float, _ radarAnchor: SCNVector3, _ baseHeight: Float) {
        super.init()
        let cylinder = buildCylinder(basicRadius, baseHeight)
        self.geometry = cylinder
        self.position = SCNVector3.init(radarAnchor.x, 0, radarAnchor.z)
        self.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: SCNPhysicsShape(geometry: cylinder, options: nil))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func buildCylinder(_ basicRadius: Float, _ baseHeight: Float) -> SCNCylinder {
        let cylinder = SCNCylinder(radius: CGFloat(basicRadius), height: CGFloat(baseHeight))
        cylinder.firstMaterial?.diffuse.contents = UIColor(red: 205/255, green: 204/255, blue: 200/255, alpha: 1)
        return cylinder
    }
}
