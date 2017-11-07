//
//  AddTableViewController.swift
//  BookYourTable
//
//  Created by Deblina Das on 06/11/17.
//  Copyright © 2017 Deblinas. All rights reserved.
//

import UIKit
import Firebase


class AddTableViewController: UIViewController {

    @IBOutlet var numberTextField: UITextField!
    var ref: DatabaseReference!
    //private lazy var activityIndicator: ActivityIndicator = ActivityIndicator(viewController: self)
    
    class func viewcontroller() -> UINavigationController {
        return UIStoryboard.init(name: "Table", bundle: nil).instantiateViewController(withIdentifier: "AddTableNavigationController") as! UINavigationController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ref = Database.database().reference()
    }

    @IBAction func addTableTapped(_ sender: UIButton) {
        guard let number = numberTextField.text, !number.isEmpty, number != "0" else {
            AlertController.present(title: "Number of Table", message: "Please add valid number of tables in your restaurant.")
            return
        }
        if let ref = ref, let numOfTables = Int(number) {
            for t in 0...numOfTables - 1{
                let request = AddTableRequest(tableID: UUID().uuidString, tableName: "Table - \(t)", isOccupied: false, customerID: nil)
                ref.child(Table.tables.rawValue).child(request.tableID).setValue(request.json)
            }
            numberTextField.resignFirstResponder()
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = ResTablesTableViewController.navigate()
        }
    }
}

struct AddTableRequest {
    var tableID: String!
    var tableName: String!
    var isOccupied: Bool!
    var customerID: String?
    
    var json: [String: Any] { return ["tableID": tableID, "tableName": tableName, "isOccupied": isOccupied, "customerID": customerID as Any]}
}

