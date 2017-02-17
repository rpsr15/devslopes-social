//
//  Post.swift
//  Devslopes Social
//
//  Created by Ravi on 17/02/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
class Post : NSObject{
    
    
    
    
    
    private var _postStory : String!
    private var _postImageURLString : String!
    private var _likes = 0
    private var _userId : String!
    private var _userName : String!
    private var _postId : String!
    
    var postStory : String{
        set{
            self._postStory = newValue
        }
        get{
        return _postStory
        }
    }
    var postImageURL : String{
        get{
             return _postImageURLString
        }
        set{
            self._postImageURLString = newValue
        }
    }
    var likes : Int{
        set{
            self._likes = newValue
            
        }
        get{
        return self._likes
        }
    }
    
    var userId : String{
        return _userId
    }
    var userName : String{
        return _userName
    }
    var postId : String{
        return _postId
    }
    
    init(id : String ,story : String? , imagePath : String? , likes : Int , userId : String , userName  : String ) {
        self._postId = id
        if let story = story{
            self._postStory = story
        }
        else{
            self._postStory = ""
        }
        
        
        if let imagePath = imagePath{
            self._postImageURLString = imagePath
        }
        else{
            self._postImageURLString = ""
        }
        self._likes = likes
        self._userId = userId
        self._userName = userName
        
        
    }
    func getDictionary() -> [String : Any]{
        var dict = [String : Any]()
        dict["imageURL"] = postImageURL
        dict["likes"] = likes
        dict["postStory"] = postStory
        dict["userId"] = userId
        dict["userName"] = userName
        
        return dict
    }
    
    override var description: String{
        return userName + userId + postStory + postImageURL + "\(likes)"
    }
    
}
