//
//  MapViewController.swift
//  EnjoyPnD
//
//  Created by Brian Vallelunga on 1/10/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    
    // MARK: Instance Variables
    private var user: User = User.current()
    private var locationManager: CLLocationManager!
    
    // MARK: UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create Location Manager
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.activityType = .Fitness
        
        if (self.locationManager.respondsToSelector(Selector("requestAlwaysAuthorization"))) {
            self.locationManager.requestAlwaysAuthorization()
        }
        
        self.locationManager.startUpdatingLocation()
        
        // Configure MapView
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        // Configure Location Label
        var buttonBorder = UIView(frame: CGRectMake(0, self.locationLabel.frame.height-1, self.view.frame.width, 1))
        buttonBorder.backgroundColor = UIColor(white: 0, alpha: 0.1)
        self.locationLabel.addSubview(buttonBorder)
    }
    
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
    
    // MARK: LocationManager Methods
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let firstLocation = locations.first as? CLLocation {
            let region = MKCoordinateRegionMakeWithDistance(firstLocation.coordinate, 1000, 1000)
            self.mapView.setCenterCoordinate(firstLocation.coordinate, animated: true)
            self.mapView.setRegion(region, animated: true)
            
            var geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(locations.last as CLLocation, completionHandler: { (placeMarks: [AnyObject]!, error: NSError!) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if placeMarks != nil && !placeMarks.isEmpty {
                        var placeMark = placeMarks[0] as CLPlacemark
                        var lines = placeMark.addressDictionary["FormattedAddressLines"] as? NSArray
                        self.locationLabel.text = lines?.firstObject as NSString
                    } else if error != nil {
                        println(error)
                    }
                })
            })
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
