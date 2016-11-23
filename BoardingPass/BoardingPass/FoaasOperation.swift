//
//  FoaasOperation.swift
//  BoardingPass
//
//  Created by Tom Seymour on 11/22/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation

//make this data convertable

class FoaasOperation: JSONConvertible, DataConvertible {
    let name: String
    let url: String
    let fields: [[String: AnyObject]]
    
    init(name: String, url: String, fields: [[String: AnyObject]]) {
        self.name = name
        self.url = url
        self.fields = fields
    }
    
    convenience required init?(json: [String : AnyObject]) {
        guard let name = json["name"] as? String,
            let url = json["url"] as? String,
        let fieldsArr = json["fields"] as? [[String: AnyObject]] else { return nil }
        
        self.init(name: name, url: url, fields: fieldsArr)
    }
    
    func toJson() -> [String : AnyObject] {
        let json: [String: AnyObject] = ["name": name as AnyObject,
                                         "url": url as AnyObject,
                                         "fields": fields as AnyObject]
        return json
    }
    
    convenience required init?(data: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            if let validJson = json {
                guard let name = validJson["name"] as? String,
                    let url = validJson["url"] as? String,
                    let fieldsArr = validJson["fields"] as? [[String: AnyObject]] else { return nil }
                self.init(name: name, url: url, fields: fieldsArr)
            }
        }
        catch {
            print("Problem casting json: \(error)")
            return nil
        }
    }
    
    func toData() throws -> Data {
        let jsonObject = self.toJson()
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            return jsonData
        }
        catch {
            print("error creating queen data: \(error)")
        }
        
    }
    
    
    
}
