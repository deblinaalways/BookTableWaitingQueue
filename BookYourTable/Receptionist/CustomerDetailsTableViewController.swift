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
        ref.child(Table.tables.rawValue).child(self.tableID).observe(.value) { snapshot in
            if let snapDict = snapshot.value as? [String: AnyObject] {
                if snapDict["isOccupied"] as? Bool == true {
                    let update = ["isOccupied": false]
                    self.ref.child(Table.tables.rawValue).child(self.tableID).child(self.customerID).removeValue()
                    self.ref.child(Table.tables.rawValue).child(self.tableID).updateChildValues(update)
                    self.ref.child(Table.customers.rawValue).child(self.customerID).removeValue()
                }
            }
            self.navigationController?.popViewController(animated: true)
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
