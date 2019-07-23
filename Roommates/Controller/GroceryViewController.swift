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
    var GroceryList : [Grocery] = [Grocery]()
    var completedGrocery: [Grocery] = [Grocery]()
    var items : [GroceryItem] = [GroceryItem]()
    let ref = Database.database().reference(withPath: "GroceryList")
    

//    Pop-over View
    @IBOutlet var ViewAddItem: UIView!
    @IBOutlet weak var lblNewItem: UITextField!
    @IBOutlet weak var lblPostedBy: UITextField!
    @IBOutlet weak var lblNumberOfItems: UILabel!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var CompletedTableView: UITableView!
    
    //    MARK: Add and Cancel Buttons
    @IBAction func btnAddNewItem(_ sender: Any) {
//        Adding the Grocery Object
        let grocery = Grocery()
        if lblNewItem.text! == "" {
            ViewAddItem.shake()
//            lblNewItem.textColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
            lblNewItem.placeholder! = "Item field is empty"
            
        }
        else{
//        Dismiss the view and reset it to normal
            lblNewItem.placeholder! = "New Item"
            self.ViewAddItem.removeFromSuperview()
            self.blur.removeFromSuperview()
           
            //Grocery Item -- Firebase
            let groceryItem = GroceryItem(name: lblNewItem.text!,
                                          addedByUser: lblPostedBy.text!,
                                          completed: false)
            // 3
            let groceryItemRef = self.ref.child(lblNewItem.text!.lowercased())
            
            // 4
            groceryItemRef.setValue(groceryItem.toAnyObject())
            
            //Assign Values
            grocery.item = lblNewItem.text!.lowercased()
            grocery.postedby = lblPostedBy.text!.lowercased()
            grocery.status = false
            GroceryList.append(grocery)
        }
        //Reload tableView
        TableView.reloadData()
        //Reset the textfield values to nil
        resetText()
    }
    
    @IBAction func btncancel(_ sender: Any) {
        self.ViewAddItem.removeFromSuperview()
        self.blur.removeFromSuperview()
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
        print(ref)
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
        //Second Table View
        CompletedTableView.delegate = self
        CompletedTableView.dataSource = self
        CompletedTableView.register(UINib(nibName: "CompletedTableViewCell", bundle: nil), forCellReuseIdentifier: "completedCell")
        CompletedTableView.separatorStyle = .none
        // Do any additional setup after loading the view.
        ref.observe(.value, with: { snapshot in
            var newItems: [GroceryItem] = []
            for child in snapshot.children{
                if let snapshot = child as? DataSnapshot,
                    let groceryItem = GroceryItem(snapshot: snapshot){
                    newItems.append(groceryItem)
                }
            }
            self.items = newItems
            self.TableView.reloadData()
        })
        
    }
    
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows : Int = Int()
        if tableView == self.TableView{
             rows = items.count
        }
        else if tableView == self.CompletedTableView{
            rows =  completedGrocery.count
        }
       return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellToReturn = UITableViewCell()
        
        if tableView == self.TableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroceryCustomCell
            cell.lblItem.text = items[indexPath.row].name
            cell.lblPostedBy.text = items[indexPath.row].addedByUser
            cell.selectionStyle = .none
            cellToReturn = cell
        }
        
        else if tableView == self.CompletedTableView {
            let Ccell = tableView.dequeueReusableCell(withIdentifier: "completedCell", for: indexPath) as! CompletedTableViewCell
            Ccell.lblCompletedItem.text = completedGrocery[indexPath.row].item
            Ccell.lblCompletedPostedBy.text = completedGrocery[indexPath.row].postedby
            Ccell.selectionStyle = .none
            cellToReturn = Ccell

        }
        lblNumberOfItems.text = "\(GroceryList.count) Items"
        return cellToReturn;
        
    }
    //MARK: - Completed Table View
    
    
    
    
    func tableView(_ tableView: UITableView,
                       leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
        {
            let status = UIContextualAction()
            var itemtoreturn = UISwipeActionsConfiguration(actions: [status])
            
            if tableView == self.TableView{
                let Completed = UIContextualAction(style: .normal, title:  "Completed", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    self.completedGrocery.append(self.GroceryList[indexPath.row])
                    self.GroceryList.remove(at: indexPath.row)
                    
                    self.TableView.deleteRows(at: [indexPath], with: .fade)
                    
                    self.CompletedTableView.reloadData()
                    //                print(self.GroceryList[indexPath.row])
                    success(true)
                    
                })
                //            closeAction.image = UIImage(named: "checked")
                Completed.backgroundColor = .white
                itemtoreturn = UISwipeActionsConfiguration(actions: [Completed])
            }
                
            else if tableView == self.CompletedTableView{
                let Completed = UIContextualAction(style: .normal, title:  "Completed", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    
                    do {
                        self.completedGrocery.remove(at: indexPath.row)
                        self.CompletedTableView.deleteRows(at: [indexPath], with: .fade)
                        self.CompletedTableView.reloadData()
                    }
                    catch{
                        print(error)
                    }
                success(true)
                    
                })
                //            closeAction.image = UIImage(named: "checked")
                Completed.backgroundColor = .white
                itemtoreturn = UISwipeActionsConfiguration(actions: [Completed])
            }
            
            return itemtoreturn
        }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let modifyAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            self.view.addSubview(self.blur)
            self.view.addSubview(self.ViewAddItem)
            self.ViewAddItem.center = self.view.center
            self.lblNewItem.text = self.GroceryList[indexPath.row].item
            self.lblPostedBy.text = self.GroceryList[indexPath.row].postedby
            self.GroceryList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            success(true)
        })
//        modifyAction.image = UIImage(named: "hammer")
        modifyAction.backgroundColor = .white
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }

    
    
        

    func resetText(){
        lblNewItem.text = ""
        lblPostedBy.text = ""
    }
    
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.5
        animation.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
        layer.add(animation, forKey: "shake")
    }
}
