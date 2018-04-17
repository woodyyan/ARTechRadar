//
//  TubeNode.swift
//  ARTechRadar
//
//  Created by Shuwen Li on 08/03/2018.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class TubeNode: SCNNode {
    init(_ innerRadius: Float, _ outterRadius: Float, _ planeAnchor: ARPlaneAnchor, _ baseHeight: Float, _ color: UIColor) {
        super.init()
        let tube = buildTube(innerRadius, outterRadius, baseHeight, color)
        self.geometry = tube
        self.position = SCNVector3.init(planeAnchor.center.x, 0, planeAnchor.center.z)
        self.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: SCNPhysicsShape(geometry: tube, options: nil))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func buildTube(_ innerRadius: Float, _ outterRadius: Float, _ baseHeight: Float, _ color: UIColor) -> SCNTube {
        let tube = SCNTube.init(innerRadius: CGFloat(innerRadius), outerRadius: CGFloat(outterRadius), height: CGFloat(baseHeight))
        tube.firstMaterial?.diffuse.contents = color
        return tube
    }
}
