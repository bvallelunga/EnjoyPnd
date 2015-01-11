//
//  HomeController.swift
//  EnjoyPnD
//
//  Created by Brian Vallelunga on 1/10/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

class HomeController: UIViewController {
    
    // MARK: Default Settings
    private struct Defaults {
        let loginButton: UIColor = UIColor(white: 0, alpha: 0.15)
        let loginDownButton: UIColor = UIColor(white: 0, alpha: 0.20)
        let registerButton: UIColor = UIColor(white: 0, alpha: 0.30)
        let registerDownButton: UIColor = UIColor(white: 0, alpha: 0.35)
    }
    
    // MARK: Instance Variables
    private let defaults = Defaults()
    
    // MARK: UIView Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check If Logged In
        if(User.current() != nil) {
            self.performSegueWithIdentifier("loggedInSegue", sender: self)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure Status Bar
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        
        // Configure Navigation Bar
        self.navigationController?.navigationBarHidden = true
    }
    
    // MARK: IBActions
    @IBAction func loginButtonInside(sender: UIButton) {
        sender.backgroundColor = self.defaults.loginButton
        self.performSegueWithIdentifier("logInSegue", sender: self)
    }
    
    @IBAction func loginButtonDown(sender: UIButton) {
        sender.backgroundColor = self.defaults.loginDownButton
    }
    
    @IBAction func loginButtonExit(sender: UIButton) {
        sender.backgroundColor = self.defaults.loginButton
    }
    
    @IBAction func registerButtonInside(sender: UIButton) {
        sender.backgroundColor = self.defaults.registerButton
        self.performSegueWithIdentifier("registerSegue", sender: self)
    }
    
    @IBAction func registerButtonDown(sender: UIButton) {
        sender.backgroundColor = self.defaults.registerDownButton
    }
    
    @IBAction func registerButtonExit(sender: UIButton) {
        sender.backgroundColor = self.defaults.registerButton
    }
}
