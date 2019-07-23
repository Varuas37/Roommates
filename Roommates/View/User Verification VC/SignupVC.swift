//
//  SignupVCViewController.swift
//  Roommates
//
//  Created by Saurav Panthee on 7/23/19.
//  Copyright © 2019 Saurav Panthee. All rights reserved.
//

import UIKit
import Firebase
class SignupVC: UIViewController {
    
    @IBOutlet weak var lblNotifyUser: UILabel!
    var email : String = ""
    var password : String = ""
    var logginIn = false
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!

    @IBAction func btnSignup(_ sender: Any) {
        
        email = txtEmail.text!
        password = txtPassword.text!
        print("I am here")
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            if error == nil{
                Auth.auth().signIn(withEmail: self.email, password: self.password)
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabController") as! tabBarViewController
                self.present(newViewController, animated: true, completion: nil)
            }
            else{
                let errorDescription = String(describing:error.debugDescription)
                if errorDescription.contains("The email address is already in use by another account"){
                    self.lblNotifyUser.text = "The email address is already in use"
                }
                if errorDescription.contains("The password must be 6 characters long or more"){
                    self.lblNotifyUser.text = "The password must be 6 characters long or more"
                }
                if errorDescription.contains("The email address is badly formatted"){
                    self.lblNotifyUser.text = "Please use a valid email address"
                }
            }
        }
        
    } //End for button
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Auth.auth().addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabControllerVC") as! tabBarViewController
                self.present(newViewController, animated: false, completion: nil)
                
            }
        }
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
