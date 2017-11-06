//
//  CustomerTableViewCell.swift
//  BookYourTable
//
//  Created by Deblina Das on 06/11/17.
//  Copyright © 2017 Deblinas. All rights reserved.
//

import UIKit

class CustomerTableViewCell: UITableViewCell {

    @IBOutlet var customerName: UILabel!
    @IBOutlet var waitingStatus: UILabel!
    
    func configureCell(customer: Customer? = nil) {
        if let customer = customer {
            self.customerName.text = customer.customerName
            if let waitTime = customer.waitTime {
                if waitTime == 0 {
                   self.waitingStatus.text = "Occupied Table"
                } else {
                    self.waitingStatus.text = "Queue - \(waitTime / 10)" }
            } else {
               self.waitingStatus.text = "Occupied Table"
            }
        }
    }

}
