//
//  FancyButton.swift
//  Devslopes Social
//
//  Created by Ravi on 14/02/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit

class FancyButton: UIButton {
    var textColor : UIColor?
    var activity : UIActivityIndicatorView?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: SHADOW_GRAY , green: SHADOW_GRAY, blue: SHADOW_GRAY  , alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 2.0
    }
    
    
    func waitforUpdate(){
        self.textColor = self.titleLabel?.textColor
        self.setTitleColor(UIColor.clear, for: .normal)
        if activity == nil {
            activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        }
        
        activity!.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activity!)
        NSLayoutConstraint(item: activity!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: activity!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        
        //let vConstraint = NSLay
        activity!.startAnimating()
        self.isEnabled = false
    }
    func endWaiting(){
        if let color = self.textColor{
            self.setTitleColor(color, for: .normal)
        }
        self.isEnabled = true
        self.activity?.isHidden = true
        self.activity?.stopAnimating()
    }

}
