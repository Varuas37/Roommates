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

    @IBOutlet weak var imgProfileImage: UIImageView!
    @IBOutlet weak var lblUsername: UITextField!
    @IBOutlet weak var lblEmail: UITextField!
    @IBOutlet weak var lblPhoneNumber: UITextField!
    var roomName = ""
    var password = ""
    var activityView:UIActivityIndicatorView!
    var imagePicker : UIImagePickerController!
    
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
         
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        imgProfileImage.isUserInteractionEnabled = true
        imgProfileImage.addGestureRecognizer(imageTap)
        imgProfileImage.layer.cornerRadius = imgProfileImage.bounds.height / 2
        imgProfileImage.clipsToBounds = true
        //tapToChangeProfileButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    @objc func openImagePicker(_ sender:Any) {
        // Open Image Picker
        self.present(imagePicker, animated: true, completion: nil)
    }
        // Do any additional setup after loading the view.
   
    }

extension CreateProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Code here
        if let pickedImage = info[.editedImage] as? UIImage  {
             self.imgProfileImage.image = pickedImage
        }
         picker.dismiss(animated: true, completion: nil)
    }
    

}
