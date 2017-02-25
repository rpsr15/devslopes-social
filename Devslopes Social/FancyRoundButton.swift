//
//  FancyRoundButton.swift
//  Devslopes Social
//
//  Created by Ravi on 20/02/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import Foundation
import UIKit
class FancyRoundButton : FancyButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 3.0
    }
    
    
    
}
