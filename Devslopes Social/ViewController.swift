//
//  ViewController.swift
//  Devslopes Social
//
//  Created by Ravi on 13/02/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper
class ViewController: UIViewController , SignupDoneDelegate{
     var currentUser  :   User?
    @IBOutlet weak var passwordTextField: FancyField!
    @IBOutlet weak var emailTextField: FancyField!
    @IBOutlet weak var emailSignInButton : FancyButton!
    @IBAction func emailSignInPressed(_ sender: FancyButton){
        
        if let email = self.emailTextField.text , let password = self.passwordTextField.text , email != "" , password != ""{
            sender.waitforUpdate()
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                if let error  = error as? NSError{
                    
                    if let errorCode = FIRAuthErrorCode(rawValue: error.code){
                        var errorMessage = ""
                        switch errorCode{
                        case .errorCodeWrongPassword:
                            errorMessage = "wrong password"
                            break;
                        case .errorCodeUserTokenExpired:
                            errorMessage = "user token expired"
                            break
                        case .errorCodeUserNotFound:
                            if let email = self.emailTextField.text , let pass = self.passwordTextField.text{
                                
                                self.registerUser(email: email, password: pass)
                            }
                            break;
                        case .errorCodeInvalidEmail:
                            errorMessage = "invalid id"
                            break;
                        
                        case .errorCodeEmailAlreadyInUse:
                            errorMessage = "email already in use"
                            break;
                        case .errorCodeNetworkError:
                            errorMessage = "Please check your network connetion"
                            break;
                         default:
                            print(error)
                        }
                        
                        displayAlert(sender : self , message: errorMessage){
                            sender.endWaiting()
                        }
                        
                    }
                }
                else{
                    self.currentUser = User()
                    self.currentUser?.uid = user?.uid
                    print("singed in \(user)")
                    sender.endWaiting()
                    
                    // TODO: MOve to next
                }
                
            }
            
        }
        
    }
    func registerUser(email: String , password: String ){
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let error  = error as? NSError{
                if let errorCode = FIRAuthErrorCode(rawValue: error.code){
                    switch errorCode{
                    case .errorCodeWeakPassword:
                        displayAlert(sender: self , message: "Password should be at least 6 characters" ){
                            self.emailSignInButton.endWaiting()
                        }
                        break;
                    default:
                        print(error)
                    }
                }
            }
            else{
                print("user registered \(user)")
                if let uid = user?.uid{
                   self.currentUser =  User()
                    self.currentUser?.uid = uid
                    
                  //  pushTo(sender: self, viewController: .SignupVC)
                   // move once back
                    if  let dest = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerType.SignupVC.rawValue) as? SignupVC{
                        dest.delegate = self
                       
                        self.present(dest, animated: true){
                             self.emailSignInButton.endWaiting()
                        }
                    }
                    
                 
            }
        }
    }
        
    }
        func setkeyChain(uid: String){
             UserDefaults.standard.setValue(uid, forKey: "uid")
           
               // self.moveTONextFeedController()
            
        }
        
        
    @IBAction func facebookLoginPressed(_ sender : AnyObject){
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error != nil){
                print(error.debugDescription)
                return
            }
            else if result?.isCancelled == true {
                print("user cancelled facebook authetication")
            }
            else{
                print("authenticated with crediential")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if(error == nil){
                print("authenticated with firebase")
                if let uid = user?.uid{
                    self.setkeyChain(uid: uid)
                }
            }
            else{
                print(error.debugDescription)
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    
    func moveTONextFeedController(){
        print("shivani : Move to feed")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
    
    // MARK: SIGNUPDONEDELEGATE
    func didComplete(userName: String, profileImage: UIImage?){
        if let uid = self.currentUser?.uid , uid != ""  , let email = self.emailTextField.text , let pass = self.passwordTextField.text{
            print("shivani did complete")
            
            self.currentUser?.userName = userName
            self.currentUser?.profileImage = profileImage
           
            //save details now 
             ref.child("users").child(uid).setValue( ["email" : email,"password" : pass , "imagepath" : "https"])

           // user.setValue(["username":userName , "password" : self.passwordTextField.text , "email" : self.emailTextField.text])
            
            //user.setValue(["password" : self.passwordTextField.text ])
            //user.setValue(["email" : self.emailTextField.text])
             self.setkeyChain(uid: uid)
              moveTONextFeedController()
        }
        else{
            displayAlert(sender : self  , message: "Couldnot register user. Please contact support team." , completion: nil)
        }
      
    }
    func userCancelledSignup() {
        self.currentUser = nil
        if let currentUser = FIRAuth.auth()?.currentUser{
            print("shivani removed user \(currentUser)")
            
            currentUser.delete(completion: nil)
        }
    }
   
}

