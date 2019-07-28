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
    
    
    @IBAction func btnAddNewRoommate(_ sender: Any) {
        //Create a user database with reference 
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
