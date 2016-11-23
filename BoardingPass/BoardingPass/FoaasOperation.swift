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
    let fields: [[String: AnyObject]] // this should be [FoaasField]
  
    init(name: String, url: String, fields: [[String: AnyObject]]) {
        self.name = name
        self.url = url
        self.fields = fields
    }
    
    convenience required init?(json: [String : AnyObject]) {
        guard let name = json["name"] as? String,
            let url = json["url"] as? String,
        let fieldsArr = json["fields"] as? [[String: AnyObject]] else { return nil }
      
        // convert fields to [FoaasField]
        self.init(name: name, url: url, fields: fieldsArr)
    }
    
    func toJson() -> [String : AnyObject] {
        return [ "name": name as AnyObject,
                 "url": url as AnyObject,
                 "fields": fields as AnyObject ]
    }
  
    // error hint: what is returned if your do-block's conditional binding fails?
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
        // this can be written in a single line. consider the following:
        // should toData() handle the exception, or should the function that calls it?
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
