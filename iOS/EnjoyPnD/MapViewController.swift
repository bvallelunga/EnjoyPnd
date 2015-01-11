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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, BallViewDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var popName: UILabel!
    @IBOutlet weak var popDescription: UILabel!
    @IBOutlet weak var popMaps: UIButton!
    @IBOutlet weak var rightCornerButton: UIBarButtonItem!
    
    // MARK: Instance Variables
    private var user: User = User.current()
    private var job: Job!
    private var locationManager: CLLocationManager!
    private var ballView: BallView!
    private var annotation: MKPointAnnotation!
    private var popupConstraint: NSLayoutConstraint!
    private let duration: NSTimeInterval = NSTimeInterval(0.2)
    private let regularColor = UIColor(red:0.18, green:0.59, blue:0.87, alpha:1)
    private let likeColor = UIColor(red:0.43, green:0.69, blue:0.21, alpha: 0.8).CGColor
    private let nopeColor = UIColor(red:0.93, green:0.19, blue:0.25, alpha: 0.8).CGColor
    
    // MARK: UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update User Status
        self.user.setStatus(2)
        
        // Create Location Manager
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.activityType = CLActivityType.AutomotiveNavigation
        
        if (self.locationManager.respondsToSelector(Selector("requestAlwaysAuthorization"))) {
            self.locationManager.requestAlwaysAuthorization()
        }
        
        self.locationManager.startUpdatingLocation()
        
        // Configure MapView
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        // Configure Location Label
        var buttonBorder = UIView(frame: CGRectMake(0, self.locationLabel.frame.height-1, self.view.frame.width, 1))
        buttonBorder.backgroundColor = UIColor(white: 0, alpha: 0.15)
        self.locationLabel.addSubview(buttonBorder)
        
        // Configure Popup View
        var popupBorder = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 1))
        popupBorder.backgroundColor = UIColor(white: 0, alpha: 0.2)
        self.popView.addSubview(popupBorder)
        
        // Configure Popup Button
        self.popMaps.layer.cornerRadius = 3
        self.popMaps.backgroundColor = UIColor(white: 0, alpha: 0.2)
        self.popMaps.alpha = 0
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
            self.user.setGeo(PFGeoPoint(location: firstLocation))
            
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
    
    @IBAction func openMapsInside(sender: UIButton) {
        self.popMaps.backgroundColor = UIColor(white: 0, alpha: 0.2)
        
        var pickup = self.job.pickup.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var destination = self.job.destination.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var url = NSURL(string: "http://maps.apple.com/maps?saddr=\(pickup)&daddr=\(destination)")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func openMapsDown(sender: UIButton) {
        self.popMaps.tintColor = UIColor.whiteColor()
        self.popMaps.backgroundColor = UIColor(white: 0, alpha: 0.35)
    }
    
    @IBAction func openMapsExit(sender: UIButton) {
        self.popMaps.backgroundColor = UIColor(white: 0, alpha: 0.2)
    }
    
    // MARK: BallView Methods
    func ballMovingAroundScreen(ball: BallView, percentage: CGFloat, delta: CGFloat) {
        var newColor: CGColor!
        
        if delta < 0 {
            newColor = self.likeColor
        } else {
            newColor = self.nopeColor
        }
        
        self.popView.backgroundColor = self.mixColors(self.regularColor.CGColor, colorTwo: newColor, delta: percentage)
    }
    
    func ballDidReturnToCenter(ball: BallView) {
        UIView.animateWithDuration(self.duration, animations: { () -> Void in
            self.popView.backgroundColor = self.regularColor
        })
    }
    
    func ballDidLeaveScreen(ball: BallView) {
        if(ball.status == .Accept) {
            self.user.setStatus(4)
            self.job.setStatus(2)
            
            UIView.animateWithDuration(self.duration, animations: { () -> Void in
                self.popMaps.alpha = 1
            })
        } else {
            self.mapView.removeAnnotation(self.annotation)
            self.job.setStatus(3)
            self.hidePopView()
        }
    }
    
    // MARK: Instance Methods
    func showPopView(job: Job) {
        job.getCompany { (company) -> Void in
            if(self.ballView != nil) {
                self.ballView.removeFromSuperview()
            }
            
            var frame = CGRectMake(self.view.frame.width/2 - 25, self.popView.frame.height - 80, 50, 50)
            self.ballView = BallView(frame: frame)
            self.ballView.delegate = self
            self.popView.addSubview(self.ballView)
            
            self.popView.backgroundColor = self.regularColor
            self.popName.text = company.name
            self.popDescription.text = job.name
            
            // Add an annotation
            var lat = CLLocationDegrees(job.pickupGeo.latitude)
            var lng = CLLocationDegrees(job.pickupGeo.longitude)
            
            if(self.annotation != nil) {
                self.mapView.removeAnnotation(self.annotation)
            }
            
            self.annotation = MKPointAnnotation()
            self.annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            self.annotation.title = "Pickup Location"
            self.annotation.subtitle = company.name
            self.mapView.addAnnotation(self.annotation)
            self.mapView.selectAnnotation(self.annotation, animated: true)
            
            self.popupConstraint = NSLayoutConstraint(item: self.popView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
            self.view.addConstraint(self.popupConstraint)
            
            UIView.animateWithDuration(self.duration, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
        
        self.job = job
    }
    
    func hidePopView() {
        self.view.removeConstraint(self.popupConstraint)
        self.popupConstraint = NSLayoutConstraint(item: self.popView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.popView.frame.height)
        self.view.addConstraint(self.popupConstraint)
        
        UIView.animateWithDuration(self.duration, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    private func mixColors(colorOne: CGColor!, colorTwo: CGColor!, delta: CGFloat) -> UIColor {
        var colorOneComp = CGColorGetComponents(colorOne)
        var colorOneRed = colorOneComp[0]
        var colorOneGreen = colorOneComp[1]
        var colorOneBlue = colorOneComp[2]
        var colorOneAlpha = colorOneComp[3]
        
        var colorTwoComp = CGColorGetComponents(colorTwo)
        var colorTwoRed = colorTwoComp[0]
        var colorTwoGreen = colorTwoComp[1]
        var colorTwoBlue = colorTwoComp[2]
        var colorTwoAlpha = colorTwoComp[3]
        
        var newRed = (colorOneRed * (1 - delta)) + (colorTwoRed * delta)
        var newGreen = (colorOneGreen * (1 - delta)) + (colorTwoGreen * delta)
        var newBlue = (colorOneBlue * (1 - delta)) + (colorTwoBlue * delta)
        var newAlpha = (colorOneAlpha * (1 - delta)) + (colorTwoAlpha * delta)
        
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: newAlpha)
    }

}
