//
//  TableViewCell.swift
//  Schrodinger
//
//  Created by Jiyeon on 2021/08/03.
//

import UIKit

class TableViewCell: UITableViewCell {

// MARK: 1. Food & Beverage_Content View
    
    @IBOutlet weak var imgFood: UIImageView!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblFoodExp: UILabel!

// MARK: 2. Cosmetics_Content View
    
    @IBOutlet weak var imgCosmetics: UIImageView!
    @IBOutlet weak var lblCosName: UILabel!
    @IBOutlet weak var lblCosExp: UILabel!
    
// MARK: 3. Medicine_Content View
    @IBOutlet weak var imgMedicine: UIImageView!
    @IBOutlet weak var lblMedsName: UILabel!
    @IBOutlet weak var lblMedsExp: UILabel!
    

}
