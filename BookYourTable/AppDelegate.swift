//
//  AppDelegate.swift
//  BookYourTable
//
//  Created by Deblina Das on 06/11/17.
//  Copyright © 2017 Deblinas. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupFramework()
        self.window?.rootViewController = HomeScreenViewController.viewController()
        return true
    }
    
    fileprivate func setupFramework() {
        FirebaseApp.configure()
    }

}

