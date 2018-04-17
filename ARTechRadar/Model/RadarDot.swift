//
//  RadarDot.swift
//  ARTechRadar
//
//  Created by Songbai Yan on 2018/4/17.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

struct RadarDot {
    var level: Level
    var quadrant: Quadrant
    var number: Int
    var name: String
    var description: String
    var position: Vector2D
}

extension RadarDot {
    var color: UIColor {
        switch quadrant {
        case .techniques:
            return UIColor.techniques
        case .tools:
            return UIColor.tools
        case .platforms:
            return UIColor.platforms
        case .languageAndFrameworks:
            return UIColor.languageAndFrameworks
        }
    }
}
