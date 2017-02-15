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
class ViewController: UIViewController {

    @IBOutlet weak var passwordTextField: FancyField!
    @IBOutlet weak var emailTextField: FancyField!
    @IBAction func emailSignInPressed(_ senderd: AnyObject){
        if let email = self.emailTextField.text , let password = self.passwordTextField.text , email != "" , password != ""{
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
                         default:
                            print(error)
                        }
                        
                        self.displayAlert(message: errorMessage)
                    }
                }
                else{
                    print("singed in \(user)")
                }
            }
        }
        
    }
    func registerUser(email: String , password: String){
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let error  = error as? NSError{
                if let errorCode = FIRAuthErrorCode(rawValue: error.code){
                    switch errorCode{
                    case .errorCodeWeakPassword:
                        self.displayAlert(message: "Password should be at least 6 characters")
                        break;
                    default:
                        print(error)
                    }
                }
            }
            else{
                print("user registered \(user)")
                if let uid = user?.uid{
                    self.setkeyChain(uid: uid)
                 
            }
        }
    }
    }
        func setkeyChain(uid: String){
             UserDefaults.standard.setValue(uid, forKey: "uid")
           
                self.moveTONextFeedController()
            
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
   
    
    func displayAlert(message : String){
        if message != "" {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .cancel , handler: nil )
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    }
    
    func moveTONextFeedController(){
        print("RAVI : Move to feed")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
   
}

