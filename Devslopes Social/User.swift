//
//  User.swift
//  Devslopes Social
//
//  Created by Ravi on 16/02/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit


class User {
    private var _uid : String!
    private var _userName : String!
    private var _profileImage : UIImage?
    
    var uid : String!{
        get{
            if _uid == nil{
                _uid = ""
            }
            return self._uid
        }
        set{
            self._uid = newValue
        }
    }
    var userName : String!{
        get{
            if _userName == nil{
                _userName = ""
            }
            return self._userName
        }
        
        set{
            self._userName = newValue
        }
    }
    
    var profileImage : UIImage?{
        get{
            return _profileImage
        }
        set{
            self._profileImage = newValue
        }
    }
}
