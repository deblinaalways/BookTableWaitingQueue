//
//  CustomerDetailsTableViewController.swift
//  BookYourTable
//
//  Created by Deblina Das on 06/11/17.
//  Copyright © 2017 Deblinas. All rights reserved.
//

import UIKit
import Firebase

class CustomerDetailsTableViewController: UITableViewController {

    @IBOutlet var emptyTableButton: UIBarButtonItem!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailIDLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    
    var ref: DatabaseReference!
    var customerID: String!
    var tableID: String!
    class func viewController(with customerID: String) -> CustomerDetailsTableViewController {
        let controller = UIStoryboard.init(name: "Table", bundle: nil).instantiateViewController(withIdentifier: "CustomerDetailsTableViewController") as! CustomerDetailsTableViewController
        controller.customerID = customerID
        return controller
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ref = Database.database().reference()
        ref.child(Table.customers.rawValue).child(customerID).observe(.value) { snapshot in
            if let snapDict = snapshot.value as? [String: AnyObject] {
                self.tableID               = snapDict["tableID"] as? String
                self.nameLabel.text        = snapDict["customerName"] as? String
                self.phoneNumberLabel.text = snapDict["mobileNumber"] as? String
                self.emailIDLabel.text     = snapDict["emailID"] as? String
            } else {
                DispatchQueue.main.async {
                    AlertController.present(title: "Error", message: "No data found with \(self.customerID)")
                }
            }
        }
    }
    
    @IBAction func emptyTheTable(_ sender: UIBarButtonItem) {
        var handle: UInt = 0
        ref.child(Table.tables.rawValue).child(self.tableID).observeSingleEvent(of: .value) { snapshot in
            if let snapDict = snapshot.value as? [String: AnyObject] {
                if snapDict["isOccupied"] as? Bool == true {
                    let update = ["isOccupied": false, "customerID": ""] as [String : Any]
                    self.ref.child(Table.tables.rawValue).child(self.tableID).updateChildValues(update)
                    self.ref.child(Table.customers.rawValue).child(self.customerID).removeValue()
                }
            }
            // assign a table with self.tableID the customer who is first in the waiting queue and update all customers waiting time
            self.addCustomerToTable(with: self.tableID)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    fileprivate func addCustomerToTable(with tableID: String) {
        ref.child(Table.customers.rawValue).observeSingleEvent(of: .value) { snapshot in
            if let snapDict = snapshot.value as? [String: AnyObject] {
                for child in snapDict {
                    // check whether customers are in waiting queue
                    if let waitTime = child.value["waitTime"] as? Int, waitTime > 0 {
                        if let customerID = child.value["customerID"] as? String {
                            let update = ["waitTime": waitTime - 10]
                            self.ref.child(Table.customers.rawValue).child(customerID).updateChildValues(update)
                            // assign table to the customer
                            if waitTime == 10 {
                                let update = ["tableID": tableID]
                                self.ref.child(Table.customers.rawValue).child(customerID).updateChildValues(update)
                                let tableUpdate = ["customerID": customerID, "isOccupied": true] as [String : Any]
                                self.ref.child(Table.tables.rawValue).child(tableID).updateChildValues(tableUpdate)
                            }
                        }
                        
                    }

                }
            }
        }
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
