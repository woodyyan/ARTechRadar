//
//  RadarNode.swift
//  ARTechRadar
//
//  Created by Shuwen Li on 2018/4/10.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import SceneKit

class RadarNode: SCNNode {
    var sphere: SphereNode
    var title: TextNode
    
    init(_ color: UIColor, _ text: String, _ x: Float, _ y: Float, _ z: Float) {
        self.sphere = SphereNode.init(color)
        self.sphere.position = SCNVector3.init(x, y, z)
        self.sphere.rotation = SCNVector4Make(1, 0, 1, Float(.pi/4.0))
        
        self.title = TextNode.init(text, color)
        title.position = SCNVector3.init(x, y, z)
    
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
