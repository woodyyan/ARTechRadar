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
    
    init(_color: UIColor, _text: String, _x: Float, _y: Float, _z: Float) {
        self.sphere = SphereNode.init(_color)
        self.sphere.position = SCNVector3.init(_x, _y, _z)
        self.sphere.rotation = SCNVector4Make(1, 0, 1, Float(.pi/4.0))
        
        self.title = TextNode.init(_text, _color)
        title.position = SCNVector3.init(_x, _y, _z)
    
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
