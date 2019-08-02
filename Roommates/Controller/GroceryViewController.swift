//
//  GroceryViewController.swift
//  Roommates
//
//  Created by Saurav Panthee on 7/21/19.
//  Copyright © 2019 Saurav Panthee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class GroceryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    //MARK: Connections and Variables
    var blur = UIVisualEffectView()
    var items : [GroceryItem] = [GroceryItem]()
    let ref = Database.database().reference(fromURL: "https://roommates-997.firebaseio.com/")
    var i = 0
    var DeleteItem = false
    let mainUserEmail = UserDefaults.standard.string(forKey: "email")
    let mainUserPassword = UserDefaults.standard.string(forKey: "password")
    let userRef = Database.database().reference(fromURL: "https://roommates-997.firebaseio.com").child("Users/\((Auth.auth().currentUser?.uid)!)")
    var databaseKey = ""
//    Pop-over View
    @IBOutlet var ViewAddItem: UIView!
    @IBOutlet weak var lblNewItem: UITextField!
    @IBOutlet weak var lblNumberOfItems: UILabel!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var UIViewBottomContainer: UIView!
    
    //    MARK: Add and Cancel Buttons
    @IBAction func btnAddNewItem(_ sender: Any) {
        
      

        if lblNewItem.text! == "" {
            ViewAddItem.shake()
            lblNewItem.placeholder! = "Item field is empty"
        }
        else if lblNewItem.text != "" {
            //Dismiss the view and reset it to normal
            lblNewItem.placeholder! = "New Item"
            dismissViewAddItem()
            
            //Grocery Item -- Firebase
            let groceryItem = GroceryItem(name: lblNewItem.text!,
                                          addedByUser: Auth.auth().currentUser?.email ?? "nil",
                                          completed: false,
                                          key: "\((self.ref.child("Grocery").child("\(databaseKey)").childByAutoId().key)!)")
            i = i+1
            // 3
            let groceryItemRef = self.ref.child("Grocery").child("\(databaseKey)").childByAutoId()
            
            // 4
            groceryItemRef.setValue(groceryItem.toAnyObject())
            
            //Assign Values
            
            //Reload tableView
            TableView.reloadData()
            //Reset the textfield values to nil
            resetText()
        }
       

    }
    
    @IBAction func btncancel(_ sender: Any) {
        dismissViewAddItem()
    }
    
    //  This is the view to add new items
    @IBAction func btnNewItem(_ sender: Any) {
        
        //Adding blur effect
        self.view.addSubview(blur)
        //Adding the popOver Subview
        self.view.addSubview(ViewAddItem)
        ViewAddItem.center = self.view.center
        
        self.view.backgroundColor = UIColor(red: 16.0/255.0, green: 195.0/255.0, blue: 130.0/255.0, alpha: 1)
    }
    
    //MARK: ViewDidLoad

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.TableView.reloadData()
        
        
        //Design few UI elements. Function is at the last of this page.
        redesign()
        if Auth.auth().currentUser?.uid == nil{
            Auth.auth().signIn(withEmail: self.mainUserEmail!, password: self.mainUserPassword!) { (user, error) in
                if error == nil {
                    print("Successful😅")
                }
                else{
                    print("❌\(error!)")
                }
            }
        }
        //Get the userDatabase
        userRef.observe(DataEventType.value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let key = value?["key"] as? String ?? ""
            self.databaseKey = key
            print(self.databaseKey)
            UserDefaults.standard.set(key, forKey: "databaseKey")
            UserDefaults.standard.synchronize()
            print("🥵\(value)")
            print("🥵😓\(self.userRef)")
        }
        
        //Blur
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blur = blurEffectView
        //First Table View
        TableView.delegate = self
        TableView.dataSource = self
        TableView.register(UINib(nibName: "GroceryCustomCell", bundle: nil), forCellReuseIdentifier: "cell")
        TableView.separatorStyle = .none
        // Do any additional setup after loading the view.
        
       let DatabaseKey = UserDefaults.standard.string(forKey: "databaseKey")
        let groceryItemRef = self.ref.child("Grocery").child("\(DatabaseKey!)")
        groceryItemRef.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            var newItems: [GroceryItem] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let groceryItem = GroceryItem(snapshot: snapshot) {
                    newItems.append(groceryItem)
                }
            }
            
            self.items = newItems
            self.TableView.reloadData()
        })
        print("😁\(self.items)")
        //Getting the reference to the database.
        
    }
    
  
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
      
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroceryCustomCell
            cell.lblItem.text = items[indexPath.row].name
            cell.lblPostedBy.text = items[indexPath.row].addedByUser
            cell.selectionStyle = .none
            if items[indexPath.row].completed{
                cell.lblPostedBy.text = "👍\(Auth.auth().currentUser?.email ?? "nil")"
                cell.UIViewColor.backgroundColor = UIColor(red: 213.0/255.0, green: 112.0/255.0, blue: 133.0/255.0, alpha: 1)
               
                }
            else{
                cell.UIViewColor.backgroundColor = UIColor(red: 16.0/255.0, green: 195.0/255.0, blue: 130.0/255.0, alpha: 1)
        }
        
        lblNumberOfItems.text = "\(items.count) Items"
        return cell
        
    }
   
    
    
    //MARK: Leading Swipe Actions
    
    func tableView(_ tableView: UITableView,
                       leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
        {
            let status = UIContextualAction()
            var itemtoreturn = UISwipeActionsConfiguration(actions: [status])
            let Completed = UIContextualAction(style: .normal, title:  "Completed", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                

                self.items[indexPath.row].completed = true
                let DatabaseKey = UserDefaults.standard.string(forKey: "databaseKey")
                let groceryItemRef = self.ref.child("Grocery").child("\(DatabaseKey!)")
                let status = groceryItemRef.child("\(self.items[indexPath.row].key)")
                status.updateChildValues(["completed":true])
                success(true)
                })

                Completed.title = "👍"
                Completed.backgroundColor = .white
                itemtoreturn = UISwipeActionsConfiguration(actions: [Completed])
            return itemtoreturn
        }
    //MARK: Trailing Swipe Action
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        let modifyAction = UIContextualAction(style: .normal, title:  "👋", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//
            self.view.addSubview(self.blur)
            //Adding the popOver Subview
            self.view.addSubview(self.CustomAlert)
            self.CustomAlert.center = self.view.center
            self.IndexPathForCell = indexPath
            success(true)
            
            
        })
        // Uncompleted
        let UnCompleted = UIContextualAction(style: .normal, title:  "Completed", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            
            self.items[indexPath.row].completed = true
            let DatabaseKey = UserDefaults.standard.string(forKey: "databaseKey")
            let groceryItemRef = self.ref.child("Grocery").child("\(DatabaseKey!)")
            let status = groceryItemRef.child("\(self.items[indexPath.row].key)")
            status.updateChildValues(["completed":false])
            success(true)
        })
        
        UnCompleted.title = "👎"
        UnCompleted.backgroundColor = .white
        
//
        modifyAction.backgroundColor = .white

        return UISwipeActionsConfiguration(actions: [modifyAction,UnCompleted])
    }

    func redesign(){
        UIViewBottomContainer.roundCornersWithLayerMask(cornerRadii: 20,corners: [.topLeft,.topRight])
        lblNewItem.layer.borderWidth = 1.0
        lblNewItem.layer.cornerRadius = 10
        lblNewItem.clipsToBounds = true
    }

    

    func resetText(){
        lblNewItem.text = ""
    }

    //Delete Item
    var IndexPathForCell = IndexPath()
    @IBOutlet var CustomAlert: UIView!
    @IBAction func btnConfirm(_ sender: Any) {
        dismissCustomAlert()
        let DatabaseKey = UserDefaults.standard.string(forKey: "databaseKey")
        let groceryItemRef = self.ref.child("Grocery").child("\(DatabaseKey!)")
        let status = groceryItemRef.child("\(self.items[IndexPathForCell.row].key)")
        status.removeValue()
        //Remove item from array
        self.items.remove(at: IndexPathForCell.row)
        self.TableView.deleteRows(at: [IndexPathForCell], with: .fade)
        self.TableView.reloadData()
    }
    @IBAction func btnExit(_ sender: Any) {
        dismissCustomAlert()
    }
    
    
    func dismissCustomAlert(){
        self.CustomAlert.removeFromSuperview()
        self.blur.removeFromSuperview()
    }
    func dismissViewAddItem(){
        self.ViewAddItem.removeFromSuperview()
        self.blur.removeFromSuperview()
    }
    
    
}//Closure for main







extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.5
        animation.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
        layer.add(animation, forKey: "shake")
    }
    func roundCornersWithLayerMask(cornerRadii: CGFloat, corners: UIRectCorner) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}

