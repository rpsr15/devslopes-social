//
//  User.swift
//  Devslopes Social
//
//  Created by Ravi on 16/02/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import Firebase


func getUIDForUserName(userName : String , completion : @escaping ( _ userid :String) -> ()){
    
    if let uid = UserDefaults.standard.value(forKey: userName) as? String{
       completion(uid)
    }
    _ = ref.child("users").child(userName).observe(.value, with: { (snapshot) in
        print(snapshot.value)
        if let dict = snapshot.value as? [String : String]{
            if let uid = dict["uid"]{
                //print(uid)
                completion(uid)
                UserDefaults.standard.set(uid, forKey: userName)
                UserDefaults.standard.synchronize()
            }
        }
    })
  
}
