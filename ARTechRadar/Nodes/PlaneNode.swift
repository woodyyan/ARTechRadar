//
//  PlaneNode.swift
//  ARTechRadar
//
//  Created by Shuwen Li on 2018/5/3.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class PlaneNode: SCNNode {
    private let height: Float = 0.03
    init(_ width: Float, _ radarAnchor: SCNVector3) {
        super.init()
        
        let plane = SCNPlane(width: CGFloat(width * 2), height: CGFloat(height))
        plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.5)
    
        self.geometry = plane
        self.position = SCNVector3.init(radarAnchor.x, 0.026, radarAnchor.z)
        self.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: SCNPhysicsShape(geometry: plane, options: nil))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
