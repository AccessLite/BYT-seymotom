//
//  FoaasField.swift
//  BoardingPass
//
//  Created by Tom Seymour on 11/22/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation

class FoaasField: JSONConvertible, CustomStringConvertible {
    let name: String
    let field: String
    
    var description: String {
        return "Name: \(name)\nField: \(field)"
    }
    
    init(name: String, field: String) {
        self.name = name
        self.field = field
    }
    
    convenience required init?(json: [String : AnyObject]) {
        guard let nam = json["name"] as? String,
            let fie = json["field"] as? String else { return nil }
        self.init(name: nam, field: fie)
    }
    
    func toJson() -> [String : AnyObject] {
        let json: [String: AnyObject] = ["name" : name as AnyObject,
                                         "field" : field as AnyObject]
        return json
    }
}
