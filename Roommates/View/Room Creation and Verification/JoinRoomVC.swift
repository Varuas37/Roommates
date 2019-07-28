//
//  JoinRoomVC.swift
//  Roommates
//
//  Created by Saurav Panthee on 7/27/19.
//  Copyright © 2019 Saurav Panthee. All rights reserved.
//

import UIKit

class JoinRoomVC: UIViewController {

    @IBOutlet weak var lblEmail: UITextField!
    @IBOutlet weak var lblPassword: UITextField!
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
        
    }
    @IBAction func btnNext(_ sender: Any) {
        //Adding the popOver Subview
     
        
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
