//
//  Job.swift
//  EnjoyPnD
//
//  Created by Brian Vallelunga on 1/11/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

import Foundation

class Job {
    
    // MARK: Instance Variables
    var name: String!
    var pickup: String!
    var pickupGeo: PFGeoPoint!
    var destination: String!
    var status: Int!
    var company: Company!
    var parse: PFObject!
    
    // MARK: Convenience Methods
    convenience init(_ job: PFObject) {
        self.init()
        
        self.parse = job
        self.name = job["name"] as? String
        self.pickup = job["pickup"] as? String
        self.pickupGeo = job["pickupGeo"] as? PFGeoPoint
        self.destination = job["destination"] as? String
        self.status = job["status"] as? Int
        
        var tempCompany = job["company"] as PFObject
        tempCompany.fetchInBackgroundWithBlock { (object: PFObject!, error: NSError!) -> Void in
            self.company = Company(object)
        }
    }
    
    // MARK: Class Methods
    class func get(id: String, callback: ((job: Job) -> Void)) {
        var job = PFObject(className: "Jobs")
        
        job.objectId = id
        job.fetchInBackgroundWithBlock { (object: PFObject!, error: NSError!) -> Void in
            if object != nil && error == nil {
                callback(job: Job(object))
            }
        }
    }
    
    // MARK: Instance Methods
    func setStatus(status: Int) {
        self.parse["status"] = status
        self.status = status
        self.parse.saveInBackgroundWithBlock(nil)
    }
    
    func getCompany(callback: ((company: Company) -> Void)) {
        var tempCompany = self.parse["company"] as PFObject
        tempCompany.fetchInBackgroundWithBlock { (object: PFObject!, error: NSError!) -> Void in
            self.company = Company(object)
            callback(company: self.company)
        }
    }
}