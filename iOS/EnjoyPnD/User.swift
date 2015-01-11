//
//  User.swift
//  EnjoyPnD
//
//  Created by Brian Vallelunga on 1/10/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

class User {
    
    // MARK: Instance Variables
    var username: String!
    var name: String!
    var email: String!
    var description: String!
    var parse: PFUser!
    
    // MARK: Convenience Methods
    convenience init(_ user: PFUser) {
        self.init()
        
        self.parse = user
        self.username = user["username"] as? String
        self.email = user["email"] as? String
        self.description = user["description"] as? String
    }
    
    // MARK: Class Methods
    class func login(email: String, password: String, callback: ((success: Bool) -> Void)) {
        PFUser.logInWithUsernameInBackground(email, password: password) {
            (user: PFUser!, error: NSError!) -> Void in
            callback(success: user != nil && error == nil)
        }
    }
    
    class func register(email: String, password: String, callback: ((success: Bool) -> Void)) {
        var user = PFUser()
        user.email = email
        user.username = email
        user.password = password
        
        user.signUpInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
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
        PFUser.logOut()
    }
}