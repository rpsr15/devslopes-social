//
//  SignupDoneDelegate.swift
//  Devslopes Social
//
//  Created by Ravi on 15/02/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit

protocol SignupDoneDelegate {
    func didComplete(userName : String, profileImagePath  : String?)
    func userCancelledSignup()
}
