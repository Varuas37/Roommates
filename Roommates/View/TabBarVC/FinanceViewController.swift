//
//  FinanceViewController.swift
//  Roommates
//
//  Created by Saurav Panthee on 8/1/19.
//  Copyright © 2019 Saurav Panthee. All rights reserved.
//

import UIKit

class FinanceViewController: UIViewController {
    @IBOutlet weak var BottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BottomView.roundCornersWithLayerMask(cornerRadii: 21, corners: [.topLeft,.topRight])

        // Do any additional setup after loading the view.
    }
    



}
