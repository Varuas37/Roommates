//
//  JoinRoomVC.swift
//  Roommates
//
//  Created by Saurav Panthee on 7/27/19.
//  Copyright © 2019 Saurav Panthee. All rights reserved.
//

import UIKit
import Firebase

class JoinRoomVC: UIViewController {

    @IBOutlet weak var lblEmail: UITextField!
    @IBOutlet weak var lblPassword: UITextField!
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
        
    }
    @IBAction func btnNext(_ sender: Any) {
        //Adding the popOver Subview
        Auth.auth().signIn(withEmail: lblEmail.text!, password: lblPassword.text!) { (user, error) in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "Sign In Failed",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "JoinRoomProfileVC") as! JoinRoomProfileVC
                self.present(newViewController, animated: true, completion: nil)
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    


}
