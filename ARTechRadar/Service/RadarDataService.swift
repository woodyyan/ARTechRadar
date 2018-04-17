//
//  RadarDataService.swift
//  ARTechRadar
//
//  Created by Songbai Yan on 2018/4/17.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

class RadarDataService {
    func getRadarDotsFromFile(url: URL) -> [RadarDot] {
        let data = NSArray(contentsOf: url)
        var dots = [RadarDot]()
        for dic in data! {
            if let dot = dic as? [String: Any] {
                let level = parseLevel(level: dot["Level"] as! String)
                let quadrant = parseQuadrant(name: dot["Quadrant"] as! String)
                let number = dot["Number"] as! Int
                let name = dot["Name"] as! String
                let description = dot["Description"] as! String
                let postion = parsePosition(postion: dot["Position"] as! [String: Any])
                let radarDot = RadarDot(level: level, quadrant: quadrant, number: number, name: name, description: description, position: postion)
                dots.append(radarDot)
            }
        }
        
        return dots
    }
    
    private func parseQuadrant(name: String) -> Quadrant {
        return Quadrant(rawValue: name)!
    }
    
    private func parseLevel(level: String) -> Level {
        return Level(rawValue: level)!
    }
    
    private func parsePosition(postion: [String: Any]) -> Vector2D {
        let x = postion["X"] as! Double
        let z = postion["Z"] as! Double
        return Vector2D(x: x, z: z)
    }
}
