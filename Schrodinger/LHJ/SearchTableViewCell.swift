//
//  SearchTableViewCell.swift
//  Schrodinger
//
//  Created by 임현진 on 2021/08/02.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var NameTitle: UILabel!
    @IBOutlet weak var ImgView: UIImageView!
    @IBOutlet weak var Date: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
