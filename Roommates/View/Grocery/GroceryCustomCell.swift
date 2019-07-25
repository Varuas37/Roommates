//
//  GroceryCustomCell.swift
//  Roommates
//
//  Created by Saurav Panthee on 7/21/19.
//  Copyright © 2019 Saurav Panthee. All rights reserved.
//

import UIKit

class GroceryCustomCell: UITableViewCell {

    @IBOutlet weak var lblItem: UILabel!
    @IBOutlet weak var lblPostedBy: UILabel!
    
    @IBOutlet weak var UIViewColor: UIView!
    
    //Completed Cell
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
