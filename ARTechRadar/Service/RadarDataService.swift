//
//  RadarDataService.swift
//  ARTechRadar
//
//  Created by Songbai Yan on 2018/4/17.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

class RadarDataService {
    func getRadarDotsFromFile(url: URL) -> [RadarDot] {
        let data = NSArray(contentsOf: url)
        for _ in data!{
            
        }
        
        return []
    }
}
