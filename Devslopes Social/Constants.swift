//
//  Constants.swift
//  Devslopes Social
//
//  Created by Ravi on 14/02/17.
//  Copyright © 2017 Ravi. All rights reserved.
//


import UIKit
import Firebase

let storage  = FIRStorage.storage()
let storageRef = storage.reference()

var ref = FIRDatabase.database().reference()
let SHADOW_GRAY : CGFloat = 120.0 / 255.0


func displayAlert(sender : UIViewController ,  message : String , completion : (() -> Void)? ){
    if message != "" {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel , handler: nil )
        alertController.addAction(alertAction)
        sender.present(alertController, animated: true, completion: completion)
    }
}
enum ViewControllerType : String{
    case ViewController = "loginVC" , FeedVC = "feedVC" , SignupVC = "signupVC" , loadingVC = "loadingVC"
}

func pushTo(sender : UIViewController , viewController : ViewControllerType){
     let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let identifier = viewController.rawValue
    var vc : UIViewController!
    switch viewController {
    case .FeedVC :
        vc = mainStoryboard.instantiateViewController(withIdentifier: identifier) as! FeedVC
    case .SignupVC :
         vc = mainStoryboard.instantiateViewController(withIdentifier: identifier) as! SignupVC
        
    case .ViewController :
        vc = mainStoryboard.instantiateViewController(withIdentifier: identifier) as! ViewController
    case .loadingVC :
        vc = mainStoryboard.instantiateViewController(withIdentifier: identifier) as! LoadingVC
        
    }
    
   
    sender.present(vc, animated: false, completion: nil)
    
}


extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

enum storyboardIdentifiers  : String {
    case MainVC = "loginVC" , SignUpVC = "signupVC" , FeedVC = "feedVC", AddPostVC = "addPostVC"
}


enum SortingCriteria : Int {
    case NewestFirst = 0 , MostLikedFirst = 1
}
