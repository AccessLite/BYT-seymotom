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
class FoaasDataManager {
    
    static let shared: FoaasDataManager = FoaasDataManager()
    private static let operationsKey: String = "FoaasOperationsKey"
    private static let defaults = UserDefaults.standard
    internal private(set) var operations: [FoaasOperation]?
    
    private init() {}
    
    
    //MARK: Methods
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
    
}
