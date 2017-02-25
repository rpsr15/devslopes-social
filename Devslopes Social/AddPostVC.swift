//
//  AddPostVCViewController.swift
//  Devslopes Social
//
//  Created by Ravi on 17/02/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import Firebase
class AddPostVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UITextViewDelegate {
    
    @IBOutlet weak var storyText: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    var post : Post!
    var uploadTask  : FIRStorageUploadTask?
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addPostButton: FancyButton!
     let imagePicker = UIImagePickerController()
    func loginUser(){
        FIRAuth.auth()?.signIn(withEmail: "rpsr15@live.in", password: "inder18#", completion: { (user, error) in
            guard let _  = error else{
                print("signed in \(user) ")
                
                return
            }
            print("erro signed in ")
        })
    }
    @IBAction func backButtonPressed(_ sender : UIButton){
        self.uploadTask?.cancel()
        self.dismiss(animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.storyText.delegate = self
       // loginUser()
       
        imagePicker.delegate = self
       // post = Post()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addImageButton(_ sender: Any) {
        
      self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func doneAddingPost(_ sender: FancyButton) {
        sender.waitforUpdate()
        let uid = UserDefaults.standard.value(forKey: "uid") as! String
        let userName = UserDefaults.standard.value(forKey: "userName") as! String
        self.post = Post(postid: nil, story: self.storyText.text, imagePath: nil, userId: uid, userName: userName )
        self.addImageButton.isEnabled = false
        var imagePath = ""
        if let image = postImage.image?.resized(toWidth: 360.0) {
            imagePath = post.postId + ".jpg"
           post.postImageURL = imagePath
            let imageRef = storageRef.child("postImages").child(imagePath)
            
            if let data = UIImageJPEGRepresentation(image, 1.0){
                uploadTask = imageRef.put(data, metadata: nil, completion: { (metadata, error) in
                    
                    if error == nil{
                        if let storyText = self.storyText.text{
                            self.post.postStory = storyText
                            self.uploadPost()
                        }
                    }
                    else{
                        print("error uploading image")
                        print(error.debugDescription)
                    }
                   
                    
                })
                
            }
            

        }else{
            if let storyText = self.storyText.text{
                self.post.postStory = storyText
                self.uploadPost()
            }
        }
           }
    
    func uploadPost(){
        print("uploading post")
         ref.child("posts").child(post.postId).setValue(post.getDictionary())
        addPostButton.endWaiting()
        self.addImageButton.isEnabled = true
        //success
        self.dismiss(animated: true, completion: nil)
    }

  
   
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
           self.postImage.image = image
            self.postImage.isHidden = false
            self.postImage.clipsToBounds = true
            self.postImage.contentMode = .scaleAspectFill
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
      view.endEditing(true)
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        view.endEditing(true)
    
    }
}
