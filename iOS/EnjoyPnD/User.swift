//
//  User.swift
//  EnjoyPnD
//
//  Created by Brian Vallelunga on 1/10/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

private var selectCompanies: NSMutableArray = NSMutableArray()
private var pendCompanies: NSMutableArray = NSMutableArray()

class User {
    
    // MARK: Instance Variables
    var username: String!
    var name: String!
    var email: String!
    var description: String!
    var status: Int!
    var lastGeo: PFGeoPoint!
    var selectedCompanies: NSMutableArray = selectCompanies
    var pendingCompanies: NSMutableArray = pendCompanies
    var parse: PFUser!
    
    // MARK: Convenience Methods
    convenience init(_ user: PFUser) {
        self.init()
        
        self.parse = user
        self.username = user["username"] as? String
        self.email = user["email"] as? String
        self.status = user["status"] as? Int
        self.description = user["description"] as? String
        self.lastGeo = user["description"] as? PFGeoPoint
    }
    
    // MARK: Class Methods
    class func login(email: String, password: String, callback: ((success: Bool) -> Void)) {
        PFUser.logInWithUsernameInBackground(email, password: password) {
            (user: PFUser!, error: NSError!) -> Void in
            var installation = PFInstallation.currentInstallation()
            installation["user"] = user
            installation.saveInBackgroundWithBlock(nil)
            callback(success: user != nil && error == nil)
        }
    }
    
    class func register(email: String, password: String, callback: ((success: Bool) -> Void)) {
        var user = PFUser()
        user.email = email
        user.username = email
        user.password = password
        user["status"] = 1
        
        user.signUpInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            var installation = PFInstallation.currentInstallation()
            installation["user"] = user
            installation.saveInBackgroundWithBlock(nil)
            callback(success: success && error == nil)
        }
    }
    
    class func current() -> User! {
        if let user = PFUser.currentUser() {
            return User(user)
        } else {
            return nil
        }
    }
    
    class func logout() {
        if PFUser.currentUser() != nil {
            PFUser.logOut()
        }
    }
    
    // MARK: Instance Methods
    func logout() {
        self.selectedCompanies.removeAllObjects()
        self.pendingCompanies.removeAllObjects()
        self.setStatus(1)
        PFUser.logOut()
    }
    
    func setInfo(name: String, description: String) {
        self.parse["name"] = name
        self.parse["description"] = description
        self.parse.saveInBackgroundWithBlock(nil)
    }
    
    func setStatus(status: Int) {
        self.parse["status"] = status
        self.status = status
        self.parse.saveInBackgroundWithBlock(nil)
    }
    
    func setGeo(geo: PFGeoPoint) {
        self.parse["lastGeo"] = geo
        self.lastGeo = geo
        self.parse.saveInBackgroundWithBlock(nil)
    }
    
    func getCompanies(callback: ((companies: [Company]) -> Void)) {
        var companies: [Company] = []
        var query = PFQuery(className: "Company")
        
        query.whereKey("workers", equalTo: self.parse)
        
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects as [PFObject] {
                    companies.append(Company(object))
                }
                
                callback(companies: companies)
            } else if error != nil {
                println(error)
            }
        })
    }
    
    func getPendingCompanies(callback: ((companies: [Company]) -> Void)) {
        var companies: [Company] = []
        var query = PFQuery(className: "Company")
        
        query.whereKey("workers", notEqualTo: self.parse)
        
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects as [PFObject] {
                    companies.append(Company(object))
                }
                
                callback(companies: companies)
            } else if error != nil {
                println(error)
            }
        })
    }
}