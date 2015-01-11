//
//  BallView.swift
//  EnjoyPnD
//
//  Created by Brian Vallelunga on 1/11/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//


//
//  ballView.swift
//  Juicy
//
//  Created by Brian Vallelunga on 8/9/14.
//  Copyright (c) 2014 Brian Vallelunga. All rights reserved.
//

import UIKit

@objc protocol BallViewDelegate {
    optional func ballWillLeaveScreen(ball: BallView)
    optional func ballDidLeaveScreen(ball: BallView)
    optional func ballWillReturnToCenter(ball: BallView)
    optional func ballDidReturnToCenter(ball: BallView)
    optional func ballMovingAroundScreen(ball: BallView, percentage: CGFloat, delta: CGFloat)
}

class BallView: UIView {
    
    // MARK: Class Enums
    enum Status {
        case None, Accept, Decline
    }
    
    private enum BallViewLocation {
        case TopLeft, TopRight, BottomLeft, BottomRight
    }
    
    // MARK: Default Settings
    struct Defaults {
        let swipeDistance: CGFloat = 75
        let border: CGFloat = 4
        let radius: CGFloat = 4
        let duration: NSTimeInterval = 0.2
        let delay: NSTimeInterval = 0
        let regualColor = UIColor.whiteColor()
        let likeColor = UIColor(red:0.43, green:0.69, blue:0.21, alpha: 0.8).CGColor
        let nopeColor = UIColor(red:0.93, green:0.19, blue:0.25, alpha: 0.8).CGColor
    }
    
    // MARK: Public Attributes
    var delegate: BallViewDelegate!
    var status: Status = .None
    var locked = true
    var startPointInSuperview: CGPoint!
    
    // MARK: Instance Attributes
    private let defaults = Defaults()
    private var neededSwipeDistance: CGFloat!
    private var hideContent: Bool!
    private var isOffScreen: Bool!
    
    // MARK: Instance Gestures
    private var panGesture: UIPanGestureRecognizer!
    
    // MARK: Convenience Init Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 1.5
        self.layer.shadowColor = UIColor(white: 0, alpha: 0.1).CGColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 0
        self.layer.shadowOffset = CGSizeMake(0, 3.0)
        self.layer.cornerRadius = frame.width/2
        self.backgroundColor = self.defaults.regualColor
    
        self.setupAttributes()
        self.setupGestures()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: BallView Methods
    private func setupAttributes() {
        self.setTranslatesAutoresizingMaskIntoConstraints(true)
        self.hideContent = false
        self.isOffScreen = false
        self.neededSwipeDistance = self.defaults.swipeDistance
        self.userInteractionEnabled = true
    }
    
    private func setupGestures() {
        self.panGesture = UIPanGestureRecognizer(target: self, action: Selector("panHandle:"))
        self.addGestureRecognizer(self.panGesture)
    }
    
    private func removeGestures() {
        self.removeGestureRecognizer(self.panGesture)
    }
    
    // MARK: Gesture Handlers
    @IBAction func panHandle(gesture: UIPanGestureRecognizer) {
        let newLocation = gesture.locationInView(self.superview)
        
        if var view = gesture.view {
            if gesture.state == UIGestureRecognizerState.Began {
                self.startPointInSuperview = newLocation;
                
                let anchor = gesture.locationInView(gesture.view)
                self.setAnchorPoint(CGPointMake(anchor.x/view.bounds.size.width, anchor.y/view.bounds.size.height), view: view)
            } else if gesture.state == UIGestureRecognizerState.Changed {
                view.layer.position = CGPointMake(newLocation.x, view.layer.position.y)
                
                let delta = self.startPointInSuperview.x - newLocation.x;
                var percentage = abs(delta/self.neededSwipeDistance)
                percentage = (percentage > 1 ? 1 : percentage)
                
                if delta < 0 {
                    self.status = .Accept
                } else {
                    self.status = .Decline
                }

                self.delegate?.ballMovingAroundScreen?(self, percentage: percentage, delta: delta)
            } else if  gesture.state == UIGestureRecognizerState.Ended {
                var ballViewLocation = self.getBallViewLocationInSuperView(newLocation)
                
                let velocity: CGPoint = gesture.velocityInView(self.superview)
                let magnitude: CGFloat = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
                let slideMult: CGFloat = magnitude / 200
                let slideFactor: CGFloat = 0.0025 * slideMult; // Increase for more of a slide
                let finalPoint: CGPoint = CGPointMake(view.layer.position.x + (velocity.x * slideFactor),
                    view.layer.position.y + (velocity.y * slideFactor));
                
                // Calculate final change in x position that was made
                let swipeDistance: Int = Int(self.startPointInSuperview.x - newLocation.x)
                let absSwipeDistance: CGFloat = CGFloat(labs(swipeDistance))
                
                if absSwipeDistance < self.neededSwipeDistance {
                    self.delegate?.ballWillReturnToCenter?(self)
                    self.returnBallViewToStartPointAnimated(true)
                } else {
                    self.delegate?.ballWillLeaveScreen?(self)
                    
                    // Animate off screen
                    UIView.animateWithDuration(self.defaults.duration, delay: self.defaults.delay, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                        var offscreenX: CGFloat!
                        let superviewOrigin = self.superview?.frame.origin
                        let superviewOriginX = superviewOrigin?.x
                        let superviewSize = self.superview?.frame.size
                        let superViewWidth = superviewSize?.width
                        let superViewHeight = superviewSize?.height
                        
                        if swipeDistance > 0 {
                            offscreenX = -superviewOriginX! - self.bounds.size.width
                        } else {
                            offscreenX = superViewWidth! + self.bounds.size.width
                        }
                        
                        view.layer.position = CGPointMake(offscreenX, view.layer.position.y)
                        }, completion: { _ in
                            self.delegate?.ballDidLeaveScreen?(self)
                            self.removeGestures()
                            self.removeFromSuperview()
                            self.returnBallViewToStartPointAnimated(false)
                    })
                }
            }
        }
    }
    
    func returnBallViewToStartPointAnimated(animated: Bool) {
        if animated {
            UIView.animateWithDuration(self.defaults.duration, delay: self.defaults.delay, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.transform = CGAffineTransformIdentity
                self.layer.position = self.startPointInSuperview
            }, completion: { _ in self.delegate?.ballDidReturnToCenter?(self); return () })
        } else {
            self.transform = CGAffineTransformIdentity
            self.layer.position = self.startPointInSuperview
        }
    }
    
    // MARK: Helper Methods
    private func setAnchorPoint(anchorPoint: CGPoint, view: UIView) {
        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
        
        var position = view.layer.position;
        
        position.x -= oldPoint.x;
        position.x += newPoint.x;
        
        position.y -= oldPoint.y;
        position.y += newPoint.y;
        
        view.layer.position = position;
        view.layer.anchorPoint = anchorPoint;
    }
    
    private func getBallViewLocationInSuperView(currentLocation: CGPoint) -> BallViewLocation {
        var result: BallViewLocation!
        let superviewSize = self.superview?.frame.size
        let superViewWidth = superviewSize?.width
        let superViewHeight = superviewSize?.height
        let middleX = superViewWidth!/2
        let middleY = superViewHeight!/2
        
        if currentLocation.x < middleX {
            if currentLocation.y < middleY {
                result = BallViewLocation.TopLeft
            } else {
                result = BallViewLocation.BottomLeft
            }
        } else {
            if currentLocation.y < middleY {
                result = BallViewLocation.TopRight
            } else {
                result = BallViewLocation.BottomRight
            }
        }
        
        return result
    }
}
