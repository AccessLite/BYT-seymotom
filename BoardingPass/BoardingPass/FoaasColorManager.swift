//
//  FoaasColorManager.swift
//  BoardingPass
//
//  Created by Tom Seymour on 1/21/17.
//  Copyright © 2017 C4Q-3.2. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class FoaasColorManager {
    
    static let shared = FoaasColorManager()
    
    var primary: UIColor! = UIColor(netHex: 0x7B1FA2)
    var primaryDark: UIColor! = UIColor(netHex: 0x9C27B0)
    var primaryLight: UIColor! = UIColor(netHex: 0xE1BEE7)
    var accent: UIColor! = UIColor(netHex: 0x69F0AE)
    
    
    private init() {}
    
    
    
}
