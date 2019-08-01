//
//  SettingsViewController.swift
//  Roommates
//
//  Created by Saurav Panthee on 7/23/19.
//  Copyright © 2019 Saurav Panthee. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    var blur = UIVisualEffectView()
    @IBOutlet var ViewAddRoommate: UIView!
    @IBOutlet weak var lblRoommateEmail: UITextField!
    @IBOutlet weak var lblPassword: UITextField!
    let key = UserDefaults.standard.string(forKey: "mainKey")
    let mainUserEmail = UserDefaults.standard.string(forKey: "email")
    let mainUserPassword = UserDefaults.standard.string(forKey: "password")
    
    @IBAction func btnAddNewRoommate(_ sender: Any) {
        
        //Create a user database with reference
        if lblPassword.text! == mainUserPassword!{
            Auth.auth().createUser(withEmail: lblRoommateEmail.text!, password: lblPassword.text!) { (authResult, error) in
                
                if error == nil{
                    Auth.auth().signIn(withEmail: self.lblRoommateEmail.text!, password: self.lblPassword.text!)
                    let ref = Database.database().reference(withPath: "Users")
                    let users = ref.child(Auth.auth().currentUser!.uid)
                    
                    let userItem = Users(username: "", email: self.lblRoommateEmail.text!, roomnumber: "", phone: "", key: self.key!)
                    users.setValue(userItem.toAnyObject())
                    try! Auth.auth().signOut()
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabBarViewController") as! tabBarViewController
                    self.present(newViewController, animated: true, completion: nil)
                }
                else{
                    print(error)
                }
            }
            blur.removeFromSuperview()
            ViewAddRoommate.removeFromSuperview()
            
        }
        else{
            ViewAddRoommate.shake()
            lblPassword.borderColor = .red
            lblPassword.placeholder = "Password don't match"
        }
    
        
        
    }
    @IBAction func btnCancel(_ sender: Any) {
       ViewAddRoommate.removeFromSuperview()
        blur.removeFromSuperview()
        
    }

    @IBAction func btnLogout(_ sender: Any) {
        try! Auth.auth().signOut()
        
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "gettingStarted") as! GettingStarted
            self.present(vc, animated: false, completion: nil)
        }
    }

    @IBAction func btnAddRoommate(_ sender: Any) {
        // This shows the option to add a new Roommate
        view.addSubview(blur)
        view.addSubview(ViewAddRoommate)
        
        ViewAddRoommate.center = view.center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blur = blurEffectView

        // Do any additional setup after loading the view.
        print(Auth.auth().currentUser?.uid)
    }
    override func viewWillAppear(_ animated: Bool) {
        
       super.viewWillAppear(true)
        if Auth.auth().currentUser?.uid == nil {
            Auth.auth().signIn(withEmail: self.mainUserEmail!, password: self.mainUserPassword!) { (user, error) in
                if error == nil{
                    print("Success✅")
                }
                else{
                    print("Sorry ❌")
                }
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
