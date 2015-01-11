//
//  LoginViewController.swift
//  EnjoyPnD
//
//  Created by Brian Vallelunga on 1/10/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    // MARK: UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Inputs
        self.emailInput.becomeFirstResponder()
        self.emailInput.delegate = self
        self.passwordInput.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure Navigation Bar
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: IBAction
    @IBAction func cancelLogin(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    // MARK: UITextField Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == self.emailInput) {
            self.passwordInput.becomeFirstResponder()
            return false
        }
        
        User.login(self.emailInput.text, password: self.passwordInput.text) { (success) -> Void in
            if(success) {
                self.performSegueWithIdentifier("loggedInSegue", sender: self)
            } else {
                self.emailInput.backgroundColor = UIColor(red:0.98, green:0.9, blue:0.9, alpha:1)
                self.passwordInput.backgroundColor = UIColor(red:0.98, green:0.9, blue:0.9, alpha:1)
                self.passwordInput.text = ""
            }

        }
        
        return true
    }
}
