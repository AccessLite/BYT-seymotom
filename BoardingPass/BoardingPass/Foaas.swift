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
        return "Message: \(message)\nSubtitle: \(subtitle)"
    }
        
    init(message: String, subtitle: String) {
        self.message = message
        self.subtitle = subtitle
    }
    
    convenience required init?(json: [String : AnyObject]) {
        guard let mes = json["message"] as? String,
            let sub = json["subtitle"] as? String else { return nil }
        self.init(message: mes, subtitle: sub)
    }
    
    func toJson() -> [String : AnyObject] {
        return ["message" : message as AnyObject,
                "subtitle" : subtitle as AnyObject]
    }
}
