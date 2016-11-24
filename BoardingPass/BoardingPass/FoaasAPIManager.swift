//
//  FoaasAPIManager.swift
//  BoardingPass
//
//  Created by Tom Seymour on 11/22/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation

class FoaasAPIManager {
    
    let endpoint = "https://www.foaas.com/awesome/louis"

    
    private static let defaultSession = URLSession(configuration: .default)
    
    internal class func getFoaas(url: URL, callback: @escaping (Foaas?) -> () ) {
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let session = defaultSession
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error: \(error)")
            }
//            guard let validData = data else { return }
//            callback(a Foaas)
            }.resume()
    }
    
    
}
