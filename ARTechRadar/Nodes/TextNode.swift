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

class TextNode: SCNNode {
    let depth = 0.008
    init(_ content: String, _ color: UIColor, _ fontName: String = "OpenSans-Regular") {
        super.init()
        let text = SCNText(string: content, extrusionDepth: CGFloat(depth))
        text.font = UIFont(name: fontName, size: 5)!
        text.firstMaterial?.diffuse.contents = color
        text.alignmentMode = kCAAlignmentCenter
        text.truncationMode = kCATruncationNone
        text.isWrapped = true

        self.geometry = text
        self.scale = SCNVector3(0.005, 0.005, 0.005)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
