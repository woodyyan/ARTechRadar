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

class CubeNode: SCNNode {
    let bottomRadius: Float = 0.01
    let height: Float = 0.01
    init(_ color: UIColor) {
        super.init()
        let cube = SCNBox.init(width: CGFloat(height), height: CGFloat(height), length: CGFloat(height), chamferRadius: 0.0)
        cube.firstMaterial?.diffuse.contents = color
        
        self.geometry = cube
        self.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: SCNPhysicsShape(geometry: cube, options: nil))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
