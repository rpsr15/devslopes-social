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

class ViewController: UIViewController , SignupDoneDelegate ,UITextFieldDelegate{
    var currentUser  :   FIRUser?
    @IBOutlet weak var passwordTextField: FancyField!
    @IBOutlet weak var emailTextField: FancyField!
    @IBOutlet weak var emailSignInButton : FancyButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    
    
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
                  
                    print("singed in \(user?.photoURL)")
                
                    self.currentUser = user
                    UserDefaults.standard.set(user?.displayName, forKey: "userName")
                    UserDefaults.standard.synchronize()
                    self.setkeyChain(uid: (user?.uid)!)
                    sender.endWaiting()
                    
                    // signed in successfully , move to feedvc
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "feedVC") as! FeedVC
                   self.present(viewController, animated: true, completion: nil)
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
            
                    self.setkeyChain(uid: (user?.uid)!)
                    if  let dest = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerType.SignupVC.rawValue) as? SignupVC{
                        dest.delegate = self
                       
                        self.present(dest, animated: true){
                             self.emailSignInButton.endWaiting()
                        }
                    }
                    
                 
            
        }
    }
        
    }
        func setkeyChain(uid: String){
             UserDefaults.standard.setValue(uid, forKey: "uid")
            UserDefaults.standard.synchronize()
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
                self.currentUser = FIRAuth.auth()?.currentUser
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
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
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
    func didComplete(userName: String, profileImagePath : String?){
       
        if let user = FIRAuth.auth()?.currentUser{
            let changeRequest = user.profileChangeRequest()
            changeRequest.displayName = userName
            if let path = profileImagePath , let url = URL(string: path){
                changeRequest.photoURL = url
            }
            ref.child("users").child(userName).setValue(["uid" : user.uid])
            changeRequest.commitChanges(completion: { (error) in
                if error != nil {
                    displayAlert(sender: self, message: "Coudlnot set username and imagepath", completion: nil)
                }
                
                // TODO: save userdefaults and move on to next viewcontroller
                UserDefaults.standard.setValue(userName, forKey: "userName")
                UserDefaults.standard.synchronize()
                
                
                
            })
            
         
        }
      
    }
    func userCancelledSignup() {
        self.currentUser = nil
        if let currentUser = FIRAuth.auth()?.currentUser{
            print("shivani removed user \(currentUser)")
            
            currentUser.delete(completion: nil)
        }
    }
   // MARK: UITextfieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       view.endEditing(true)
        return true
    }
    

}

