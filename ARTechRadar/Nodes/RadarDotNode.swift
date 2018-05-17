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
    private let y: Float = 0.08
    
    var sphere: SphereNode!
    var title: TextNode!
    var descript: DescriptionNode!
    
    init(radarDot: RadarDot) {
        super.init()
        
        self.sphere = SphereNode.init(radarDot.color)
        self.sphere.position = SCNVector3.init(radarDot.position.x, y, radarDot.position.z)
        
        self.title = TextNode.init(radarDot.name, radarDot.color)
        title.position = SCNVector3.init(radarDot.position.x, y + 0.01, radarDot.position.z)
        
        self.descript = DescriptionNode.init(radarDot.description)
        descript.position = SCNVector3.init(radarDot.position.x, y + 0.3, radarDot.position.z)
        
        self.addChildNode(sphere)
        self.addChildNode(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func displayDescription() {
        if !self.childNodes.contains(descript) {
            self.addChildNode(descript)
        } else {
            descript.removeFromParentNode()
        }
    }
}
