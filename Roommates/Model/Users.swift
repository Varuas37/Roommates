

import Firebase
import Foundation


struct Users {
    
    let ref: DatabaseReference?
    let key: String
    let username: String
    let email: String
    var roomnumber: String
    var phone: String
    
    init(username: String, email: String, roomnumber: String,phone: String, key: String = "") {
        self.ref = nil
        self.key = key
        self.username = username
        self.email = email
        self.roomnumber = roomnumber
        self.phone = phone
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let username = value["username"] as? String,
            let email = value["email"] as? String,
            let phone = value["phone"] as? String,
            let roomnumber = value["roomnumber"] as? String else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.username = username
        self.email = email
        self.roomnumber = roomnumber
        self.phone = phone
    }
    
    func toAnyObject() -> Any {
        return [
            "username": username,
            "email": email,
            "roomnumber": roomnumber,
            "key": key,
            "phone" : phone
        ]
    }
}
