//
//  FoaasProtocols.swift
//  BoardingPass
//
//  Created by Tom Seymour on 11/22/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation

protocol JSONConvertible {
    init?(json: [String : AnyObject])
    func toJson() -> [String : AnyObject]
}

protocol DataConvertible {
    init?(data: Data)
    func toData() throws -> Data
}
