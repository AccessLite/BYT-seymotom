//
//  FoaasAPIManager.swift
//  BoardingPass
//
//  Created by Tom Seymour on 11/22/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation

class FoaasAPIManager {
    
    let louisFoaasEndpoint = "https://www.foaas.com/awesome/louis"
    
    
    private static let defaultSession = URLSession(configuration: .default)
    
    internal class func getFoaas(url: URL, callback: @escaping (Foaas?) -> () ) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error encountered with getFoaas: \(error)")
            }
            if response != nil {
                print(">>>>>>>>> URLResponse for get Foaas: \(response)")
            }
            do {
                let dictFromData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                if let unwrappedDict = dictFromData {
                    let thisFoaas = Foaas(json: unwrappedDict)
                    callback(thisFoaas)
                }
            }
            catch {
                print("error encountered with JSONSerialization in getFoaas: \(error)")
            }
            }.resume()
    }
    
    internal class func getOperations(callback: @escaping ([FoaasOperation]? ) -> () ) {
        let operationEndpoint = "http://www.foaas.com/operations"
        let operationURL = URL(string: operationEndpoint)!
        var request = URLRequest(url: operationURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error encountered with getOperations: \(error)")
            }
            if response != nil {
                print(">>>>>>>>> URLResponse for getOperations: \(response)")
            }
            
            do {
                let arrayFromData = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String: AnyObject]]
                if let unwrappedArray = arrayFromData {
                    let operationsArr: [FoaasOperation] = unwrappedArray.flatMap { FoaasOperation(json: $0) }
                    callback(operationsArr)
                }
            }
            catch {
                print("error encountered with JSONSerialization in getOperations: \(error)")
            }
            
            }.resume()
    }
}
