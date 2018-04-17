//
//  RadarNode.swift
//  ARTechRadar
//
//  Created by Shuwen Li on 2018/4/10.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import SceneKit

class RadarDotNode: SCNNode {
    private let y = 0.0
    
    var sphere: SphereNode
    var title: TextNode
    
    init(radarDot: RadarDot) {
        self.sphere = SphereNode.init(radarDot.color)
        self.sphere.position = SCNVector3.init(radarDot.position.x, y, radarDot.position.z)
        self.sphere.rotation = SCNVector4Make(1, 0, 1, Float(.pi/4.0))
        
        self.title = TextNode.init(radarDot.name, radarDot.color)
        title.position = SCNVector3.init(radarDot.position.x, y, radarDot.position.z)
    
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
