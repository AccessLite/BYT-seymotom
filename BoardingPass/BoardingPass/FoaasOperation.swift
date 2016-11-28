//
//  FoaasOperation.swift
//  BoardingPass
//
//  Created by Tom Seymour on 11/22/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation

class FoaasOperation: JSONConvertible, DataConvertible {
    let name: String
    var url: String
    let fields: [FoaasField]
    
    init(name: String, url: String, fields: [FoaasField]) {
        self.name = name
        self.url = url
        self.fields = fields
    }
    
    convenience required init?(json: [String : AnyObject]) {
        guard let name = json["name"] as? String,
            let url = json["url"] as? String,
        let fieldsArr = json["fields"] as? [[String: AnyObject]] else { return nil }
        let foaasFieldArr: [FoaasField] = fieldsArr.flatMap { FoaasField(json: $0) }
        self.init(name: name, url: url, fields: foaasFieldArr)
    }
    
    func toJson() -> [String : AnyObject] {
        return  ["name": name as AnyObject,
                 "url": url as AnyObject,
                 "fields": self.fields.map { $0.toJson() } as AnyObject]
    }
    
    convenience required init?(data: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            if let validJson = json {
                self.init(json: validJson)
            } else {
                return nil
            }
        }
        catch {
            print("Problem casting json: \(error)")
            return nil
        }
    }
    
    func toData() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self.toJson(), options: [])
    }
}
