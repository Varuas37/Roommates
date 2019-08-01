

import Firebase
import Foundation


struct Users {
    
    let ref: DatabaseReference?
    let key: String
    let username: String
    let email: String
    var roomnumber: String
    var phone: String
    var admin: Bool
    
    init(username: String, email: String, roomnumber: String,phone: String,admin:Bool, key:String = "") {
        self.ref = nil
        self.key = key
        self.username = username
        self.email = email
        self.roomnumber = roomnumber
        self.phone = phone
        self.admin = admin
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let username = value["username"] as? String,
            let email = value["email"] as? String,
            let phone = value["phone"] as? String,
            let roomnumber = value["roomnumber"] as? String,
            let admin = value["admin"] as? Bool else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.username = username
        self.email = email
        self.roomnumber = roomnumber
        self.phone = phone
        self.admin = admin
    }
    
    func toAnyObject() -> Any {
        return [
            "username": username,
            "email": email,
            "roomnumber": roomnumber,
            "key": key,
            "phone" : phone,
            "admin" : admin
        ]
    }
}
