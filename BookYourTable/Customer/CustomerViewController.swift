//
//  CustomerViewController.swift
//  BookYourTable
//
//  Created by Deblina Das on 07/11/17.
//  Copyright © 2017 Deblinas. All rights reserved.
//

import UIKit
import Firebase
class CustomerViewController: UIViewController {

    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var emailIDTextField: UITextField!
    
    var ref: DatabaseReference!
    var emailID: String!
    
    class func viewController() -> CustomerViewController {
        return UIStoryboard.init(name: "Customer", bundle: nil).instantiateViewController(withIdentifier: "CustomerViewController") as! CustomerViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.label1.text = "Check your emailID"
        self.label2.text = ""
    }
    
    @IBAction func signoutButtonTapped(_ sender: UIButton) {
        try! Auth.auth().signOut()
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        guard let emailID = emailIDTextField.text, !emailID.isEmpty else {
            AlertController.present(title: "Email ID", message: "Enter valid email id.")
            return
        }
        self.emailID = emailID
        emailIDTextField.resignFirstResponder()
        configureUI()
    }
    
    func configureUI() {
        ref.child(Table.customers.rawValue).observe(DataEventType.value) { snapshot in
            if let customers = snapshot.value as? [String: AnyObject] {
                for customer in customers {
                    if let emailID = customer.value["emailID"] as? String, emailID == self.emailID {
                        if let tableID = customer.value["tableID"] as? String {
                            self.ref.child(Table.tables.rawValue).child(tableID).observeSingleEvent(of: .value, with: { snapshot in
                                if let table = snapshot.value as? [String: AnyObject] {
                                    let tableName = table["tableName"] as? String
                                    DispatchQueue.main.async {
                                        self.label1.text = "Congrats! table has been booked"
                                        self.label2.text = tableName!
                                    }
                                }
                            })
                        } else if let waitTime = customer.value["waitTime"] as? Int, waitTime > 0 {
                            DispatchQueue.main.async {
                                self.label1.text = "Queue - \(waitTime / 10)"
                                self.label2.text = "Avg waiting time: \(waitTime) mins"
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.label1.text = "You are not registered yet"
                            self.label2.text = ""
                        }
                    }
                }
                
            } else { // customer doesn't exist in the database
                DispatchQueue.main.async {
                    self.label1.text = "You are not registered yet"
                    self.label2.text = ""
                }
            }
        }
    }
}
