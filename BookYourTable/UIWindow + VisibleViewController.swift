//
//  UIWindow + VisibleViewController.swift
//  BookYourTable
//
//  Created by Deblina Das on 06/11/17.
//  Copyright © 2017 Deblinas. All rights reserved.
//

import UIKit

extension UIWindow {
    
    class func visibleViewController() -> UIViewController? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let window = appDelegate?.window
        if let rootViewController: UIViewController = window?.rootViewController {
            return UIWindow.getVisibleViewController(startingViewController: rootViewController)
        } else {
            return nil
        }
    }
    
    private class func getVisibleViewController(startingViewController: UIViewController) -> UIViewController? {
        if let navigationController = startingViewController as? UINavigationController {
            return navigationController.visibleViewController
        } else if let tabBarController = startingViewController as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return getVisibleViewController(startingViewController: selectedViewController)
            }
        } else if let presentedViewController = startingViewController.presentedViewController {
            return getVisibleViewController(startingViewController: presentedViewController)
        }
        return startingViewController
    }
    
}
