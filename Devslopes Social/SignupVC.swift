//
//  SignupVC.swift
//  Devslopes Social
//
//  Created by Ravi on 15/02/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import Firebase
class SignupVC: UIViewController , UIImagePickerControllerDelegate , UITextFieldDelegate , UINavigationControllerDelegate {
    var profileImage : UIImage?
    var imagePicker  : UIImagePickerController?
    var delegate : SignupDoneDelegate?
    @IBOutlet weak var userProfileThumb : UIButton!
    @IBOutlet weak var userNameTextField : UITextField!
    @IBAction func doneEditingPressed(_ sender : AnyObject){
        if let userName = self.userNameTextField.text , userName != "" {
            
            var imagePath  : String? = nil
            if let image = profileImage , let data = UIImagePNGRepresentation(image){
                imagePath = FIRAuth.auth()?.currentUser?.uid ?? "\(userName)\(NSDate.timeIntervalSinceReferenceDate)"
            storageRef.child("userPhotos").child(imagePath!).put(data)
                
            }
            
            delegate?.didComplete(userName: userName, profileImagePath: imagePath)
            self.dismiss(animated: true, completion: nil)
           
        }
        else{
        displayAlert(sender: self, message: "Please select username", completion: nil)
        }
    }
    @IBAction func backButtonPressed(_ sender : AnyObject){
        delegate?.userCancelledSignup()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func selectUserThumb(_ sender : AnyObject){
        self.present(imagePicker!, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userNameTextField.delegate = self
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        self.userProfileThumb.imageView?.contentMode = .scaleAspectFit
        self.userProfileThumb.imageView?.layer.cornerRadius = 10.0
        self.userProfileThumb.imageView?.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MAKR: Imagepickercontrollerdelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            print("got the image ")
            self.profileImage = image.resized(toWidth: 80)
            self.userProfileThumb.setImage(self.profileImage, for: .normal)
        }
        self.imagePicker?.dismiss(animated: true, completion: nil)
        //
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //
        
        self.imagePicker?.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }

}
