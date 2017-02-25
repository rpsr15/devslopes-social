//
//  FeedVC.swift
//  Devslopes Social
//
//  Created by Ravi on 15/02/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import Firebase
class FeedVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    var displayName : String!
    var uid : String!
    @IBOutlet weak var tableView : UITableView!
    var posts = [Post]()
    fileprivate var isDownloading = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 229.0
        tableView.rowHeight = UITableViewAutomaticDimension
      //  setObservers()
        
        self.displayName = UserDefaults.standard.value(forKey: "userName") as! String
        self.uid = UserDefaults.standard.value(forKey: "uid") as! String
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        downloadData()
    }
    
    @IBAction func addPostButtonPressed(_ sender : UIButton){
       performSegue(withIdentifier: "addPostVC", sender: nil)
    }
    
    
    @IBAction func signOutButtonPressed(_ sender : UIButton){
        UserDefaults.standard.removeObject(forKey: "uid")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.synchronize()
        print("signing out")
        do {
            try FIRAuth.auth()?.signOut()
            
            //TODO: move to login screen
           self.dismiss(animated: true, completion: nil)
        }
        catch let error as NSError{
            print("could not signout \(error.debugDescription)")
        }
    }
    
    @IBAction func segmentViewChanged(_sender : Any){
        if isDownloading == false {
        let sortingCriteria = SortingCriteria(rawValue: self.segment.selectedSegmentIndex)
        
        self.posts = posts.sorted(by: { (p1, p2) -> Bool in
            if (sortingCriteria == .NewestFirst){
                return p1.createdOn < p2.createdOn
            }
            else{
                return p1.likes > p2.likes
            }
        })
        self.tableView.reloadData()
    }
    }
    
    @IBOutlet weak var segment : UISegmentedControl!
    
    
    func downloadData(){
        self.isDownloading = true
        ref.child("posts").observe( FIRDataEventType.value, with: { (snapshot) in
            if let dicts = snapshot.value as? [String : Any]{
                let sortingCriteria = SortingCriteria(rawValue: self.segment.selectedSegmentIndex)
                self.parsePostData(dicts: dicts, parseCriteria: sortingCriteria!, completion: { (posts) in
                  //  print(posts)
                    
                   // DispatchQueue.main.async {
                        self.posts = posts
                        self.tableView.reloadData()
                    self.isDownloading = false
                    //}
                    
                })
            }
            else{
                print("SHIVANI: coudlnt not parse value")
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func parsePostData(dicts : [String : Any],parseCriteria : SortingCriteria ,completion : ( _ posts : [Post]) ->  () ) {
        var postsToReturn = [Post]()
        for (postid,postData) in dicts{
            if let postData = postData as? [String : Any]{
                let imageURL = postData["imageURL"] as! String
                
                let postStory = postData["postStory"] as! String
                let userId = postData["userId"] as! String
                let userName = postData["userName"] as! String
               
                
                
                let post = Post(postid: postid, story: postStory, imagePath: imageURL, userId: userId, userName: userName)
                if  let likedByDicts = postData["likedBy"] as? [String : Any]{
                  let usersLiked = Array(likedByDicts.keys)
                    post.likedBy = usersLiked
                }
                else{
                    post.likedBy = [String]()
                }
                
                
                postsToReturn.append(post)
            }
        
      
        }
        
        completion(postsToReturn.sorted(by: { (p1, p2) -> Bool in
            if (parseCriteria == .NewestFirst){
                return p1.createdOn < p2.createdOn
            }
            else{
                return p1.likes > p2.likes
            }
        }))
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "socialCell") as? SocialCell{
            
            let post = posts[indexPath.row]
            cell.currentPost = post
            cell.configurePost(post: post)
            return cell
        }
        else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         let cell = tableView.dequeueReusableCell(withIdentifier: "socialCell", for: indexPath) as! SocialCell
        cell.cancelImageDownload()
        
            
       
    }
    
    

}
