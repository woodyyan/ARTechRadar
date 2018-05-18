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
    var radarDot: RadarDot!
    
    init(radarDot: RadarDot) {
        super.init()
        
        self.radarDot = radarDot
        self.sphere = SphereNode.init(radarDot.color)
        self.sphere.position = SCNVector3.init(radarDot.position.x, y, radarDot.position.z)
        
        self.title = TextNode.init(truncateTitle(radarDot.name), radarDot.color)
        let (min, max) = title.boundingBox
        title.position = SCNVector3.init(radarDot.position.x, y + 0.01, radarDot.position.z)
        title.pivot = SCNMatrix4MakeTranslation((max.x - min.x) / 2, 0, 0)
        
        self.descript = DescriptionNode.init(generateDescription())
        descript.position = SCNVector3.init(radarDot.position.x, y + 0.25, radarDot.position.z)
        
        self.addChildNode(sphere)
        self.addChildNode(title)
    }
    
    private func generateDescription() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "")
        
        attributedString.append(NSAttributedString(string: radarDot.name + "\n", attributes: [NSAttributedStringKey.foregroundColor : radarDot.color, NSAttributedStringKey.font: UIFont(name: "OpenSans-SemiBold", size: 22)!]))
        
        attributedString.append(NSAttributedString(string: radarDot.description, attributes: [NSAttributedStringKey.font: UIFont(name: "OpenSans-Light", size: 14)!]))
        
        return attributedString
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
            self.sphere.geometry?.materials[0].emission.contents = self.radarDot.color
        } else {
            descript.removeFromParentNode()
            self.sphere.geometry?.materials[0].emission.contents = UIColor.black
        }
    }
}
