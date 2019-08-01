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
    var roomName = ""
    var password = ""
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated:true)
    }
    
    @IBAction func lblNext(_ sender: Any) {
        
        let email = lblEmail.text!
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            if error == nil{
                UserDefaults.standard.set(self.password,forKey: "password")
                UserDefaults.standard.set(self.lblEmail.text!, forKey: "email")
                UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "mainKey")
                UserDefaults.standard.synchronize()
                guard let username = self.lblUsername.text, let email = self.lblEmail.text, let phone = self.lblPhoneNumber.text else{
                    return
                }
                Auth.auth().signIn(withEmail: email, password: self.password)
                let ref = Database.database().reference(withPath: "Users")
                let users = ref.child(Auth.auth().currentUser!.uid)
                let userItem = Users(username: username, email: email, roomnumber: self.roomName, phone: phone, admin : true, key: (Auth.auth().currentUser?.uid)!)
                users.setValue(userItem.toAnyObject())
          
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabBarViewController") as! tabBarViewController
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
