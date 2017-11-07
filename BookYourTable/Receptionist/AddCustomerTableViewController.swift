//
//  AddCustomerTableViewController.swift
//  BookYourTable
//
//  Created by Deblina Das on 06/11/17.
//  Copyright © 2017 Deblinas. All rights reserved.
//

import UIKit
import Firebase

class AddCustomerTableViewController: UITableViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailIDTextField: UITextField!
    @IBOutlet var mobileNumberTextField: UITextField!
    
    var ref: DatabaseReference!
    var tableReference: DatabaseReference!
    var tableID: String!
    
    class func viewcontroller(to tableID: String, tableReference: DatabaseReference) -> AddCustomerTableViewController {
        let controller = UIStoryboard.init(name: "Table", bundle: nil).instantiateViewController(withIdentifier: "AddCustomerTableViewController") as! AddCustomerTableViewController
        controller.tableID = tableID
        controller.tableReference = tableReference
        return controller
    }
    
    class func viewController() -> AddCustomerTableViewController {
        return UIStoryboard.init(name: "Table", bundle: nil).instantiateViewController(withIdentifier: "AddCustomerTableViewController") as! AddCustomerTableViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ref = Database.database().reference()
        if self.tableID == nil && self.tableReference == nil {
            checkTableFree()
        }
    }
    
    fileprivate func checkTableFree() {
        var handle: UInt = 0
        handle = ref.child(Table.tables.rawValue).observe(.value) { snapshot in
            if snapshot.childrenCount > 0 , let snapDict = snapshot.value as? [String: AnyObject] {
                for child in snapDict {
                    if child.value["isOccupied"] as! Bool == false {
                        self.tableID = child.value["tableID"] as! String
                        continue
                    }
                }
                // a new reference
                self.tableReference = Database.database().reference()
            }
            self.ref.removeObserver(withHandle: handle)
        }
    }

    var customerCount = 0
    var tableCount = 0
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text, !name.isEmpty else {
            AlertController.present(title: "Name", message: "Add Customer Name")
            return
        }
        guard let emailID = emailIDTextField.text, !emailID.isEmpty else {
            AlertController.present(title: "Email ID", message: "Add Customer Email ID")
            return
        }
        guard let mobileNumber = mobileNumberTextField.text, !mobileNumber.isEmpty else {
            AlertController.present(title: "Mobile Number", message: "Add Customer Mobile Number")
            return
        }
        if let ref = ref {
            var handle: UInt = 0
            var customerID: String? = UUID().uuidString
            let request = AddCustomerRequest(userID: customerID!, tableID: self.tableID, userName: name, emailID: emailID, mobileNumber: mobileNumber, waitTime: 0)
            // Add Customer
            ref.child(Table.customers.rawValue).child(request.userID).setValue(request.json)
            ref.child(Table.customers.rawValue).observeSingleEvent(of: .value, with: { cust_snapshot in
                self.customerCount = Int(cust_snapshot.childrenCount)
                if cust_snapshot.childrenCount > 0  {
                    var _handle: UInt = 0
                    ref.child(Table.tables.rawValue).observeSingleEvent(of: .value, with: { table_snapshot in
                        self.tableCount = Int(table_snapshot.childrenCount)
                        if cust_snapshot.childrenCount <= table_snapshot.childrenCount && self.tableID != nil && self.tableReference != nil && customerID != nil {
                            // reserve table for this customer, no waiting queue
                            let update = ["customerID": customerID!, "isOccupied": true] as [String : Any]
                            self.tableReference.child(Table.tables.rawValue).child(self.tableID).updateChildValues(update)
                            //ref.removeObserver(withHandle: _handle)
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            let avgWaitTime = 10
                            let extraCustomer =  self.customerCount - self.tableCount
                            let update = ["waitTime": avgWaitTime * extraCustomer]
                            ref.child(Table.customers.rawValue).child(customerID!).updateChildValues(update)
                            //ref.removeObserver(withHandle: _handle)
                            // customer is in waiting queue
                            // notify customer by alert
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    })
                }
                ref.removeObserver(withHandle: handle)
            })
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

struct AddCustomerRequest {
    var userID: String!
    var tableID: String?
    var userName: String!
    var emailID: String!
    var mobileNumber: String!
    var waitTime: Int?
    var json: [String: Any] { return ["customerID": userID, "tableID": tableID as Any, "customerName": userName, "emailID": emailID, "mobileNumber": mobileNumber, "waitTime": waitTime as Any]}
}
