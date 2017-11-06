//
//  TableViewCell.swift
//  BookYourTable
//
//  Created by Deblina Das on 06/11/17.
//  Copyright © 2017 Deblinas. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var tableName: UILabel!
    @IBOutlet var isOccupiedImageView: UIImageView!
    
    func configureCell(with data: TableData? = nil) {
        if let data = data {
            DispatchQueue.main.async {
                self.tableName.text = data.tableName
                self.isOccupiedImageView.image = data.isOccupied ? #imageLiteral(resourceName: "filled") : #imageLiteral(resourceName: "empty")
            }
        } else {
            DispatchQueue.main.async {
                self.tableName.text = ""
                self.isOccupiedImageView.image = #imageLiteral(resourceName: "filled")
            }
        }
    }
    

}
