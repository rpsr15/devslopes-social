//
//  SocialCell.swift
//  Devslopes Social
//
//  Created by Ravi on 17/02/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import Firebase

class SocialCell : UITableViewCell {
    var currentPost : Post!
    var userName : String!
    @IBOutlet weak var userProfileThumb: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    private var downloadTask : FIRStorageDownloadTask?
    private var userProfileDownloadTask : FIRStorageDownloadTask?
    override func awakeFromNib() {
        super.awakeFromNib()
        getUser()
    }
    func getUser(){
         userName = UserDefaults.standard.value(forKey: "userName") as! String
    }
    @IBOutlet weak var likedButton: UIButton!
    @IBAction func likedButtonPressed(_ sender: UIButton) {
        
        print("liked button pressed")
        if (currentPost.isLikedBy(userName: userName)){
            unlikedPost()
            currentPost.unLikedByUser(userName: userName)
        }
        else{
            likedPost()
            currentPost.likedPost(userName: userName)
        }
        
    }
    func likedPost(){
        print("post liked")
        self.likedButton.setImage(UIImage(named: "liked"), for: .normal)
    }
    
    func unlikedPost(){
        self.likedButton.setImage(UIImage(named: "notLiked"), for: .normal)
    }
     required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        getUser()
        
    }
    func cancelImageDownload(){
        if (self.downloadTask != nil){
            self.downloadTask?.cancel()
            self.downloadTask = nil
            print("chau cancellig inage donwload task")
        }
    }
    func configurePost(post : Post){
        
        if post.likedBy.contains(userName){
            self.likedButton.isHighlighted = true
        }
        self.userNameLabel.text = post.userName
        
        if  post.postStory != "" {
            self.descriptionLabel.text = post.postStory
            self.descriptionLabel.isHidden = false
        }
        else{
            self.descriptionLabel.isHidden = true
        }
        if  post.postImageURL != ""{
            //set image
            
            self.postImage.isHidden = false
        }
        else{
            self.postImage.isHidden = true
        }
        self.likesLabel.text = "\(post.likes)"
        //download cell image
        
        getUIDForUserName(userName: post.userName) { (uid) in
            self.userProfileDownloadTask = storageRef.child("userPhotos").child(uid).data(withMaxSize: 100000, completion: { (data, error) in
                if error == nil {
                    if let data = data , let image = UIImage(data: data){
                        DispatchQueue.main.async {
                            self.userProfileThumb.image = image
                        }
                    }
                }
            })
        }
        
        if post.postImageURL != ""{
        
         let imageRef = storageRef.child("postImages").child(post.postImageURL)
            print("hello world \(imageRef)")
            downloadTask =  imageRef.data(withMaxSize: 10000000, completion: { (data, error) in
                if error == nil {
                    print("image downloaded \(data)")
                    if let data = data {
                        if let image = UIImage(data: data){
                            DispatchQueue.main.async {
                                self.postImage.image = image
                            }
                        }
                    }
                }
                else{
                    print("error has occured while download media \(error)")
                }
            })
        }
    }
    
    
    
}
