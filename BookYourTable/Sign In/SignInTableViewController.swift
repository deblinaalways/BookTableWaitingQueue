//
//  SignInTableViewController.swift
//  BookYourTable
//
//  Created by Deblina Das on 06/11/17.
//  Copyright © 2017 Deblinas. All rights reserved.
//

import UIKit
import Firebase

class SignInTableViewController: UITableViewController {

    @IBOutlet var emailIDTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var invalidCellHeight = CGFloat(0.0)
    private lazy var activityIndicator: ActivityIndicator = ActivityIndicator(viewController: self)
    var signInType: SignInType!
    
    class func viewController(with type: SignInType) -> SignInTableViewController {
        let controller = UIStoryboard.init(name: "Sign In", bundle: nil).instantiateViewController(withIdentifier: "SignInTableViewController") as! SignInTableViewController
        controller.signInType = type
        return controller
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Sign In"
    }

    // TODO: emailID verification
    @IBAction func emailIDTextFieldEditingChanged(_ sender: UITextField) {
        configureInvalidCell()
    }
    
    fileprivate func configureInvalidCell() {
        if emailIDTextField.text!.isEmpty || !emailIDTextField.text!.contains("@") {
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                self.invalidCellHeight = CGFloat(10.0)
                self.tableView.endUpdates()
            }
        } else {
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                self.invalidCellHeight = CGFloat(0.0)
                self.tableView.endUpdates()
            }
        }
    }
    
    // Minimal password validation
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let emailID = emailIDTextField.text, !emailID.isEmpty else {
            AlertController.present(title: "Email ID", message: "Please enter valid email ID.")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            AlertController.present(title: "Password", message: "Please enter a valid password.")
            return
        }
        self.view.endEditing(true)
        signIn(with: emailID, password: password)
    }
    
    fileprivate func signIn(with emailID: String, password: String) {
        self.activityIndicator.start()
        Auth.auth().signIn(withEmail: emailID, password: password) { (user, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.activityIndicator.stop()
                    AlertController.present(title: "Sign In Error", message: error.localizedDescription)
                }
            } else if let user = user {
                DispatchQueue.main.async {
                    self.activityIndicator.stop()
                    AlertController.present(title: "Sign In", message: "Sign In Successful.", from: self, okAction: {
                        self.checkTablesExist()
                    })
                }
            }
        }
    }
    
    var ref: DatabaseReference!
    fileprivate func checkTablesExist() {
        self.ref = Database.database().reference()
        ref.child(Table.tables.rawValue).observe(.value) { snapshot in
            if snapshot.childrenCount > 0 {
               (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = ResTablesTableViewController.navigate()
            } else {
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = AddTableViewController.viewcontroller()
            }
        }
    }
    
}

extension SignInTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            return invalidCellHeight
        default:
            return 60
        }
    }
}
