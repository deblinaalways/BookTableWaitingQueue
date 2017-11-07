//
//  ResTablesTableViewController.swift
//  BookYourTable
//
//  Created by Deblina Das on 06/11/17.
//  Copyright © 2017 Deblinas. All rights reserved.
//

import UIKit
import Firebase

/***
 To read data at a path and listen for changes, use the observeEventType:withBlock orobserveSingleEventOfType:withBlock methods of FIRDatabaseReference to observe FIRDataEventTypeValue events.
 */
class ResTablesTableViewController: UITableViewController {
    var ref: DatabaseReference!
    var tableList: [TableData]!
    @IBOutlet var customerButton: UIBarButtonItem!
    
    class func navigate() -> UINavigationController {
        let navigationController = UIStoryboard.init(name: "Table", bundle: nil).instantiateViewController(withIdentifier: "ResTableNavigationController") as! UINavigationController
        return navigationController
    }
    
    class func viewController() -> ResTablesTableViewController {
        return UIStoryboard.init(name: "Table", bundle: nil).instantiateViewController(withIdentifier: "ResTablesTableViewController") as! ResTablesTableViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Tables"
        configureTableUI()
    }
    
    fileprivate func configureTableUI() {
        self.tableList = [TableData]()
        if let ref = ref {
            ref.child(Table.tables.rawValue).observeSingleEvent(of: .value) { snapshot in
                if snapshot.childrenCount > 0 , let snapDict = snapshot.value as? [String: AnyObject] {
                    for child in snapDict {
                        let tableID    = child.value["tableID"] as? String
                        let tableName  = child.value["tableName"] as? String
                        let isOccupied = child.value["isOccupied"] as? Bool
                        var customerID: String?
                        if let id = child.value["customerID"] as? String { customerID = id }
                        let data = TableData(tableID: tableID, tableName: tableName, isOccupied: isOccupied, customerID: customerID)
                        self.tableList.append(data)
                    }
                    self.tableView.reloadData()
                } else { // No table found
                    self.present(AddTableViewController.viewcontroller(), animated: true, completion: nil)
                }
            }
        }
    }

    @IBAction func signOutButtonTapped(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
    }
    
    @IBAction func customerListButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(CustomerListTableViewController.viewController(), animated: true)
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableList.count > 0 && tableList != nil ? tableList.count : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        if tableList.count != 0 {
            cell.configureCell(with: tableList[indexPath.row])
        }
        else { cell.configureCell() }
        return cell
    }
    
    // if the table is occupied, it will show the customer details on the next page, or, will let receptionist to reserve a table for a new customer on next page
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableList.count != 0 {
            if tableList[indexPath.row].isOccupied, let customerID = tableList[indexPath.row].customerID {
               self.navigationController?.pushViewController(CustomerDetailsTableViewController.viewController(with: customerID), animated: true)
            } else {
                self.navigationController?.pushViewController(AddCustomerTableViewController.viewcontroller(to: tableList[indexPath.row].tableID, tableReference: self.ref), animated: true)
            }
        }
    }
    
}

struct TableData {
    var tableID: String!
    var tableName: String!
    var isOccupied: Bool!
    var customerID: String?
}
