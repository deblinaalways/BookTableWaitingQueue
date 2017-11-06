//
//  HomeScreenViewController.swift
//  BookYourTable
//
//  Created by Deblina Das on 06/11/17.
//  Copyright © 2017 Deblinas. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {

    @IBOutlet var customerSignInButton: UIButton!
    @IBOutlet var receptionSignInButton: UIButton!
    
    class func viewController() -> UINavigationController {
        return UIStoryboard.init(name: "Sign In", bundle: nil).instantiateViewController(withIdentifier: "homeScreenNavigationController") as! UINavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func customerSignInButtonTapped(_ sender: UIButton) {
        self.navigationController?.pushViewController(SignInTableViewController.viewController(with: .customer), animated: true)
    }
    
    @IBAction func receptionistSignInButtonTapped(_ sender: UIButton) {
        self.navigationController?.pushViewController(SignInTableViewController.viewController(with: .receptionist), animated: true)
    }
}

enum SignInType: String {
    case receptionist = "Receptionist"
    case customer = "Customer"
}
