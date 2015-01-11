//
//  AddInfoController.swift
//  EnjoyPnD
//
//  Created by Brian Vallelunga on 1/10/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

class AddInfoController: UIViewController, UITextFieldDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextField!
    @IBOutlet weak var skipButton: UIBarButtonItem!
    
    // MARK: Instance Variables
    private var user: User = User.current()
    
    // MARK: UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Inputs
        self.nameInput.becomeFirstResponder()
        self.nameInput.delegate = self
        self.descriptionInput.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure Navigation Bar
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.skipButton.setTitleTextAttributes([
            NSFontAttributeName: UIFont.systemFontOfSize(20)
        ], forState: UIControlState.Normal)
    }
    
    // MARK: IBActions
    @IBAction func skipInfo(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("registeredSegue", sender: self)
    }
    
    // MARK: UITextField Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == self.nameInput) {
            self.descriptionInput.becomeFirstResponder()
            return false
        }
        
        user.setInfo(self.nameInput.text, description: self.descriptionInput.text)
        self.performSegueWithIdentifier("registeredSegue", sender: self)
        return true
    }
}
