//
//  WindowExtension.swift
//  EnjoyPnD
//
//  Created by Brian Vallelunga on 1/11/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        
        if vc.isKindOfClass(UINavigationController.self) {
            
            let navigationController = vc as UINavigationController
            return UIWindow.getVisibleViewControllerFrom( navigationController.visibleViewController)
            
        } else if vc.isKindOfClass(UITabBarController.self) {
            
            let tabBarController = vc as UITabBarController
            return UIWindow.getVisibleViewControllerFrom(tabBarController.selectedViewController!)
            
        } else {
            
            if let presentedViewController = vc.presentedViewController {
                
                return UIWindow.getVisibleViewControllerFrom(presentedViewController.presentedViewController!)
                
            } else {
                
                return vc;
            }
        }
    }
}
