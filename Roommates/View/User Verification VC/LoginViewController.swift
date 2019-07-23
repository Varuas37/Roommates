//
//  LoginViewController.swift
//  Roommates
//
//  Created by Saurav Panthee on 7/23/19.
//  Copyright © 2019 Saurav Panthee. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    var email = ""
    var password = ""
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func btnLogin(_ sender: Any) {
        email = txtEmail.text!
        password = txtPassword.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "Sign In Failed",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabControllerVC") as! tabBarViewController
                self.present(newViewController, animated: true, completion: nil)
            }
           
        }
        
       
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Auth.auth().addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabControllerVC") as! tabBarViewController
                self.present(newViewController, animated: true, completion: nil)
                self.txtEmail.text = nil
                self.txtPassword.text = nil
            }
        }
    }

}
