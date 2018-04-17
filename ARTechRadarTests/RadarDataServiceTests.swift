//
//  RadarDataServiceTests.swift
//  ARTechRadarTests
//
//  Created by Songbai Yan on 2018/4/17.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import XCTest

class RadarDataServiceTests: XCTestCase {
    
    private let radarDataService = RadarDataService()
    
    func testExample() {
        let url = Bundle.main.url(forResource: "RadarData", withExtension: ".plist")
        let dots = radarDataService.getRadarDotsFromFile(url: url!)
        
        XCTAssert(dots.count > 0)
    }
}
