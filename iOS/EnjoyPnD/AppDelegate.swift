//
//  AppDelegate.swift
//  EnjoyPnD
//
//  Created by Brian Vallelunga on 1/10/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        //Initialize Parse
        ParseCrashReporting.enable()
        Parse.setApplicationId("cJZxV4SMJNcriFmT5jQD4qY6tgQjo2Ci1WYN0IHc", clientKey: "1H2W80UK8vU73k94zD7I4nPqanmoslAo8IqVP8bv")
        
        // Register for Push Notitications, if running iOS 8
        if application.respondsToSelector(Selector("registerUserNotificationSettings:")) {
            let notificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
            let settings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            
            // Register for Push Notifications before iOS 8
        } else {
            let notificationTypes = UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound
            application.registerForRemoteNotificationTypes(notificationTypes)
        }
        
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        if application.applicationState != UIApplicationState.Background {
            let preBackgroundPush = !application.respondsToSelector(Selector("backgroundRefreshStatus"))
            let oldPushHandlerOnly = !self.respondsToSelector(Selector("application:didReceiveRemoteNotification:fetchCompletionHandler:"))
            let noPushPayload = (launchOptions?.objectForKey(UIApplicationLaunchOptionsRemoteNotificationKey) == nil)
            
            if preBackgroundPush || oldPushHandlerOnly || noPushPayload {
                PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
            }
        }
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let infoDictionary = NSBundle.mainBundle().infoDictionary!
        let version = infoDictionary["CFBundleShortVersionString"] as NSString
        let build = infoDictionary[kCFBundleVersionKey] as NSString
        var installation = PFInstallation.currentInstallation()
        
        installation.setDeviceTokenFromData(deviceToken)
        installation.addUniqueObject("termsChanged", forKey: "channels")
        installation.addUniqueObject("juicyPost", forKey: "channels")
        installation.addUniqueObject("juicyUser", forKey: "channels")
        installation.addUniqueObject("sharedPost", forKey: "channels")
        installation.setObject("\(version) - \(build)", forKey: "appVersionBuild")
        installation.saveInBackgroundWithBlock(nil)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        if application.applicationState == UIApplicationState.Inactive {
            // The application was just brought from the background to the foreground,
            // so we consider the app as having been "opened by a push notification."
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayloadInBackground(userInfo, block: nil)
        }
        
        if var user = User.current() {
            if let action = userInfo["action"] as? String {
                if action == "job.invite" {
                    var window = UIApplication.sharedApplication().keyWindow
                    var controller = window?.visibleViewController() as? MapViewController
                    
                    if user.status == 2 {
                        if let id = userInfo["job"] as? String {
                            Job.get(id, callback: { (element) -> Void in
                                var job = element as Job
                                controller?.showPopView(job)
                            })
                        }
                    }
                }
            }
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        User.current()?.setStatus(1)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        User.current()?.setStatus(1)
    }

}

