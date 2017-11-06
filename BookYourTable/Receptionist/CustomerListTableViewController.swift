//
//  CustomerListTableViewController.swift
//  BookYourTable
//
//  Created by Deblina Das on 06/11/17.
//  Copyright © 2017 Deblinas. All rights reserved.
//

import UIKit
import Firebase

class CustomerListTableViewController: UITableViewController {

    
    var customerList: [Customer]!
    var ref: DatabaseReference!
    
    class func viewController() -> CustomerListTableViewController {
        return UIStoryboard.init(name: "Table", bundle: nil).instantiateViewController(withIdentifier: "CustomerListTableViewController") as! CustomerListTableViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ref = Database.database().reference()
        configureTableUI()
    }
    
    fileprivate func configureTableUI() {
        self.customerList = [Customer]()
        if let ref = ref {
            ref.child(Table.customers.rawValue).observe(.value) { snapshot in
                if snapshot.childrenCount > 0 , let snapDict = snapshot.value as? [String: AnyObject] {
                    for child in snapDict {
                        let customerID    = child.value["customerID"] as! String//["tableID"].stringValue
                        let name  = child.value["customerName"] as! String
                        let emailID = child.value["emailID"] as! String
                        let mobileNumber = child.value["mobileNumber"] as! String
                        var waitTime: Int?
                        if let time = child.value["waitTime"] as? Int { waitTime = time }
                        let data = Customer(customerID: customerID, customerName: name, emailID: emailID, mobileNumber: mobileNumber, waitTime: waitTime)
                        self.customerList.append(data)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func addCustomer(_ sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(AddCustomerTableViewController.viewController(), animated: true)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return customerList.count > 0 ? customerList.count : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "customerCell", for: indexPath) as! CustomerTableViewCell
        if customerList.count != 0 {
           cell.configureCell(customer: customerList[indexPath.row])
        } else {
            cell.configureCell()
        }
        return cell
    }
    

}

struct Customer {
    var customerID: String!
    var customerName: String!
    var emailID: String!
    var mobileNumber: String!
    var waitTime: Int?
}
