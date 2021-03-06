//
//  Foaas.swift
//  BoardingPass
//
//  Created by Tom Seymour on 11/22/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation

class Foaas: JSONConvertible, CustomStringConvertible {
    internal let message: String
    internal let subtitle: String
    
    var description: String {
        return "\(message)\n\(subtitle)"
    }
        
    init(message: String, subtitle: String) {
        self.message = message
        self.subtitle = subtitle
    }
    
    convenience required init?(json: [String : AnyObject]) {
        guard let message = json["message"] as? String,
            let subtitle = json["subtitle"] as? String else { return nil }
        self.init(message: message, subtitle: subtitle)
    }
    
    func toJson() -> [String : AnyObject] {
        return ["message" : message as AnyObject,
                "subtitle" : subtitle as AnyObject]
    }
}
