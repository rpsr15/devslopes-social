//
//  Post.swift
//  Devslopes Social
//
//  Created by Ravi on 17/02/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
class Post : NSObject{
    
    
    
    private var _likedBy : [String]!
    private var _createdOn : TimeInterval!
    private var _postStory : String!
    private var _postImageURLString : String!
    private var _likes : Int {
        return self._likedBy.count
    }
    private var _userId : String!
    private var _userName : String!
    private var _postId : String!
    
    var likedBy  : [String]!{
        get{
            return self._likedBy
        }
        set{
            self._likedBy = newValue
        }
    }
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
    
    var createdOn : TimeInterval{
        return self._createdOn
    }
    
    init(postid : String?, story : String? , imagePath : String?  , userId : String , userName  : String  ) {
        if postid == nil {
            self._postId =  "\(userId)\(Int(NSDate().timeIntervalSince1970))"
            print("human post id is nil creating default \(self._postId)")
        }
        else{
            print("human post id is present \(self._postId)")
            self._postId = postid
        }
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
        
        self._userId = userId
        self._userName = userName
        self._createdOn = NSDate().timeIntervalSince1970
        
        self._likedBy = [String]()
        
    }
    func getDictionary() -> [String : Any]{
        var dict = [String : Any]()
        dict["imageURL"] = postImageURL
        dict["likes"] = likes
        dict["postStory"] = postStory
        dict["userId"] = userId
        dict["userName"] = userName
        dict["createdOn"] = _createdOn
        dict["likedBy"] = getLikedByDict(likedBy: likedBy)
        return dict
    }
    
    override var description: String{
        return userName + userId + postStory + postImageURL + "\(likes)"
    }
    
    func update(){
        ref.child("posts").child(self.postId).updateChildValues(self.getDictionary())
    }
    func likedPost(userName : String){
        if !likedBy.contains(userName){
            likedBy.append(userName)
            update()
        }
    }
    
    func unLikedByUser(userName : String){
        if likedBy.contains(userName){
            if   let indexOf = likedBy.index(of: userName){
                likedBy.remove(at: indexOf)
                update()
            }
        }
    }
    
    func isLikedBy(userName :String) -> Bool{
        return self.likedBy.contains(userName)
    }
    
    func getLikedByDict(likedBy : [String]) -> [String : Bool]{
        var result = [String : Bool]()
        for t in likedBy {
            result[t] = true
        }
        return result
    }
    
}


