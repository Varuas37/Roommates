//
//  CompletedTableViewCell.swift
//  Roommates
//
//  Created by Saurav Panthee on 7/22/19.
//  Copyright © 2019 Saurav Panthee. All rights reserved.
//

import UIKit

class CompletedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCompletedPostedBy: UILabel!
    @IBOutlet weak var lblCompletedItem: UILabel!
    @IBOutlet weak var Color: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
