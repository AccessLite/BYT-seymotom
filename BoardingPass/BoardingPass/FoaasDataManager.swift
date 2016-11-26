//
//  FoaasDataManager.swift
//  BoardingPass
//
//  Created by Tom Seymour on 11/26/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation

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
    }
    
}
