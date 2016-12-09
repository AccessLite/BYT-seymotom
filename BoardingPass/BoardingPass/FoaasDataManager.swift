//
//  FoaasDataManager.swift
//  BoardingPass
//
//  Created by Tom Seymour on 11/26/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation

// Get used to the idea that you need to always be testing a "first use" case to simulate what would happen the first
// time a user downloads your app.

enum FoulLanguageFilter {
    case isOn, isOff
}

class FoaasDataManager {
    
    static let shared: FoaasDataManager = FoaasDataManager()
    
    private static let operationsKey: String = "FoaasOperationsKey"
    private static let defaults = UserDefaults.standard
    internal private(set) var operations: [FoaasOperation]?
    
    var filter: FoulLanguageFilter = .isOn
    
    static var foaasEndpointURL = URL(string: "https://www.foaas.com/because/Anonymous")!
    
    private init() {}
    
    
    //MARK: Methods
    
    internal func requestOperations(_ operations: @escaping ([FoaasOperation]?) -> Void) {
        if FoaasDataManager.shared.load() == false {
            FoaasAPIManager.getOperations(callback: { (operations: [FoaasOperation]?) in
                if let unwrappedOperationsArray = operations {
                    print(">>>>>>> Got operations array from api...")
                    dump(unwrappedOperationsArray)
                    // saves in dataManager.shared.operations
                    FoaasDataManager.shared.save(operations: unwrappedOperationsArray)
                }
            })
        }
        else {
            print(">>>>>> Got operations array from defaults...")
            dump(FoaasDataManager.shared.operations)
        }
    }
    
    
    func save(operations: [FoaasOperation]) {
        let operationData:[Data] = operations.flatMap { try? $0.toData() }
        FoaasDataManager.defaults.set(operationData, forKey: FoaasDataManager.operationsKey)
        FoaasDataManager.shared.operations = operations // need this as well, otherwise on first run no data actually loads in your table view
        print("successfully saved [FoaasOperation]")
    }
    
    func load() -> Bool {
        if let savedDataFromDefaults = FoaasDataManager.defaults.value(forKey: FoaasDataManager.operationsKey) as? [Data] {
            let operationsArray = savedDataFromDefaults.flatMap { FoaasOperation(data: $0) }
            FoaasDataManager.shared.operations = operationsArray
            print("successfully loaded [FoaasOperation]")
            return true
        } else {
            return false
        }
    }
    
    func deleteStoredOperations() {
        FoaasDataManager.defaults.set(nil, forKey: FoaasDataManager.operationsKey)
        FoaasDataManager.shared.operations = nil // good practice to also get rid of the data from your manager
    }
    
    internal class func getFoaas(url: URL, completionHandler: @escaping (Foaas?) -> () ) {
        FoaasAPIManager.getFoaas(url: url) { (thisFoaas) in
            if thisFoaas != nil {
                completionHandler(thisFoaas)
            }
        }
    }
    
    
    
    
}
