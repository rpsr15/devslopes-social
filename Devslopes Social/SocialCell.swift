//
//  SocialCell.swift
//  Devslopes Social
//
//  Created by Ravi on 17/02/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit


class SocialCell : UITableViewCell {
    @IBOutlet weak var userProfileThumb: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
     required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
    }
    
    func configurePost(post : Post){
        self.userNameLabel.text = post.userName
        if let desc = post.descriptionText {
            self.descriptionLabel.text = desc
            self.descriptionLabel.isHidden = false
        }
        else{
            self.descriptionLabel.isHidden = true
        }
        if let imagePath = post.postImageURLString{
            //set image
            
            self.postImage.isHidden = false
        }
        else{
            self.postImage.isHidden = true
        }
        self.likesLabel.text = "\(post.likes)"
        
    }
    
    
    
}
