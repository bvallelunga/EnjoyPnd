//
//  Company.swift
//  EnjoyPnD
//
//  Created by Brian Vallelunga on 1/10/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

class Company {
    
    // MARK: Instance Variables
    var name: String!
    var description: String!
    var parse: PFObject!
    
    // MARK: Convenience Methods
    convenience init(_ company: PFObject) {
        self.init()
        
        self.parse = company
        self.name = company["name"] as? String
        self.description = company["description"] as? String
    }
    
    // MARK: Instance Methods
    func addWorker(user: User) {
        var relation = self.parse.relationForKey("workers")
        
        relation.addObject(user.parse)
        user.selectedCompanies.addObject(self.parse.objectId)
        
        self.parse.saveInBackgroundWithBlock(nil)
    }
    
    func removeWorker(user: User) {
        var relation = self.parse.relationForKey("workers")
        
        relation.removeObject(user.parse)
        user.selectedCompanies.removeObject(self.parse.objectId)
        
        self.parse.saveInBackgroundWithBlock(nil)
    }
    
    func addPendingWorker(user: User) {
        var relation = self.parse.relationForKey("pendingWorkers")
        
        relation.addObject(user.parse)
        user.pendingCompanies.addObject(self.parse.objectId)
        
        self.parse.saveInBackgroundWithBlock(nil)
    }
    
    func removePendingWorker(user: User) {
        var relation = self.parse.relationForKey("pendingWorkers")
        
        relation.removeObject(user.parse)
        user.pendingCompanies.removeObject(self.parse.objectId)
        
        self.parse.saveInBackgroundWithBlock(nil)
    }
}