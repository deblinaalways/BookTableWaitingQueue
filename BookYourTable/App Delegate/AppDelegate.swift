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
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                print(user.email ?? "")
                if user.email == "recep@gmail.com" {
                    self.window?.rootViewController = ResTablesTableViewController.navigate()
                } else if user.email == "customer@gmail.com" {
                    self.window?.rootViewController = CustomerViewController.viewController()
                }
            } else {
                self.window?.rootViewController = HomeScreenViewController.viewController()
            }
        }
        
        return true
    }
    
    fileprivate func setupFramework() {
        FirebaseApp.configure()
    }

}

