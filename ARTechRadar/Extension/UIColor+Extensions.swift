//
//  UIColor+Extensions.swift
//  ARTechRadar
//
//  Created by Songbai Yan on 2018/4/17.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public static var techniques: UIColor {
        return UIColor(red: 45, green: 188, blue: 204)!
    }
    
    public static var tools: UIColor {
        return UIColor(red: 135, green: 182, blue: 132)!
    }
    
    public static var platforms: UIColor {
        return UIColor(red: 241, green: 137, blue: 71)!
    }
    
    public static var languageAndFrameworks: UIColor {
        return UIColor(red: 177, green: 36, blue: 89)!
    }
    
    public convenience init?(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        guard red >= 0 && red <= 255 else { return nil }
        guard green >= 0 && green <= 255 else { return nil }
        guard blue >= 0 && blue <= 255 else { return nil }
        
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }
    
    func darkerColor(percent : Double) -> UIColor {
        return colorWithBrightnessFactor(factor: CGFloat(1 - percent));
    }
    
    /**
     Return a modified color using the brightness factor provided
     
     :param: factor brightness factor
     :returns: modified color
     */
    func colorWithBrightnessFactor(factor: CGFloat) -> UIColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
        } else {
            return self;
        }
    }
}
