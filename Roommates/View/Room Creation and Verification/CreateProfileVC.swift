//
//  CreateProfileVC.swift
//  Roommates
//
//  Created by Saurav Panthee on 7/27/19.
//  Copyright © 2019 Saurav Panthee. All rights reserved.
//

import UIKit
import Firebase

class CreateProfileVC: UIViewController {

    
    @IBOutlet weak var lblUsername: UITextField!
    @IBOutlet weak var lblEmail: UITextField!
    @IBOutlet weak var lblPhoneNumber: UITextField!
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated:true)
    }
    
    @IBAction func lblNext(_ sender: Any) {
        let password = UserDefaults.standard.string(forKey: "password")
        let email = lblEmail.text!
        Auth.auth().createUser(withEmail: email, password: password!) { (authResult, error) in
            
            if error == nil{
                Auth.auth().signIn(withEmail: email, password: password!)
                let ref = Database.database().reference(withPath: "Users")
                let users = ref.child(Auth.auth().currentUser!.uid)
                
          
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabControllerVC") as! tabBarViewController
                self.present(newViewController, animated: true, completion: nil)
            }
            else{
                print("Problem")
            }
        }

        
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
