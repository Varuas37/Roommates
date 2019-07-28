//
//  JoinRoomProfileVC.swift
//  Roommates
//
//  Created by Saurav Panthee on 7/27/19.
//  Copyright © 2019 Saurav Panthee. All rights reserved.
//

import UIKit

class JoinRoomProfileVC: UIViewController {

    @IBOutlet weak var lblUsername: UITextField!
    @IBOutlet weak var lblPhoneNumber: UIView!
    
    @IBAction func btnNext(_ sender: Any) {
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated:true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
