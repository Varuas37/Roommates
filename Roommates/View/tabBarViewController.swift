//
//  tabBarViewController.swift
//  Roommates
//
//  Created by Saurav Panthee on 7/23/19.
//  Copyright © 2019 Saurav Panthee. All rights reserved.
//
import UIKit
import Firebase


class tabBarViewController: UITabBarController {
    let mainUserEmail = UserDefaults.standard.string(forKey: "email")
    let mainUserPassword = UserDefaults.standard.string(forKey: "password")

    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if Auth.auth().currentUser?.uid == nil{
            Auth.auth().signIn(withEmail: self.mainUserEmail!, password: self.mainUserPassword!) { (user, error) in
                if error == nil {
                    print("Successful😅")
                    
                }
                else{
                    print("❌\(error)")
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
