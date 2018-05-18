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
        
        self.title = TextNode.init(truncateTitle(radarDot.name), radarDot.color)
        let (min, max) = title.boundingBox
        title.position = SCNVector3.init(radarDot.position.x, y + 0.01, radarDot.position.z)
        title.pivot = SCNMatrix4MakeTranslation((max.x - min.x) / 2, 0, 0)
        
        self.descript = DescriptionNode.init(radarDot.description)
        descript.position = SCNVector3.init(radarDot.position.x, y + 0.3, radarDot.position.z)
        
        self.addChildNode(sphere)
        self.addChildNode(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func truncateTitle(_ title: String) -> String {
        let maxTitleLength = 12
        if title.count >= maxTitleLength {
            return title.prefix(maxTitleLength) + "..."
        }
        return title
    }
    
    public func displayDescription() {
        if !self.childNodes.contains(descript) {
            self.addChildNode(descript)

        } else {
            descript.removeFromParentNode()
        }
    }
}
