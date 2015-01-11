//
//  MapViewController.swift
//  EnjoyPnD
//
//  Created by Brian Vallelunga on 1/10/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

class MapViewController: UIViewController {
    
    // MARK: Instance Variables
    private var user: User = User.current()
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: UIViewController Overrides
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure Navigation Bar
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.18, green:0.59, blue:0.87, alpha:1)
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        
        // Create Text Shadow
        var shadow = NSShadow()
        shadow.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.1)
        shadow.shadowOffset = CGSizeMake(0, 2);
        
        if let font = UIFont(name: "Ubuntu", size: 22) {
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: font,
                NSShadowAttributeName: shadow
            ]
        }
    }

    
    // MARK: IBActions
    @IBAction func addCompanies(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    @IBAction func logoutUser(sender: UIBarButtonItem) {
        self.user.logout()
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
}
