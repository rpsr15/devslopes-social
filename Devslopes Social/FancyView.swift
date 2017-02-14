//
//  FancyView.swift
//  Devslopes Social
//
//  Created by Ravi on 14/02/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit

class FancyView: UIView {

    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame : CGRect){
        super.init(frame: frame)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: SHADOW_GRAY , green: SHADOW_GRAY, blue: SHADOW_GRAY  , alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
    

}
