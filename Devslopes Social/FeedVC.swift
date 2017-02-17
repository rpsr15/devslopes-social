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
    
    @IBOutlet weak var tableView : UITableView!
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 229.0
        tableView.rowHeight = UITableViewAutomaticDimension
        setObservers()
        downloadData()
        // Do any additional setup after loading the view.
    }
    
    func setObservers(){
        ref.child("posts").observe(.childAdded) { (snapshot) in
            print(snapshot.value)
        }
    }
    func downloadData(){
        ref.child("posts").observe( FIRDataEventType.value, with: { (snapshot) in
            if let dicts = snapshot.value as? [String : Any]{
                self.parsePostData(dicts: dicts, completion: { (posts) in
                    print(posts)
                    
                   // DispatchQueue.main.async {
                        self.posts = posts
                        self.tableView.reloadData()
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
    func parsePostData(dicts : [String : Any] ,completion : ( _ posts : [Post]) ->  () ) {
        var postsToReturn = [Post]()
        for (postid,postData) in dicts{
            if let postData = postData as? [String : Any]{
                let imageURL = postData["imageURL"] as! String
                let likes = postData["likes"] as! Int
                let postStory = postData["postStory"] as! String
                let userId = postData["userId"] as! String
                let userName = postData["userName"] as! String
                  let post = Post(id: postid, story: postStory, imagePath: imageURL, likes: likes, userId: userId, userName: userName)
                postsToReturn.append(post)
            }
        
      
        }
        completion(postsToReturn)
        
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
            cell.configurePost(post: post)
            return cell
        }
        else{
            return UITableViewCell()
        }
    }

}
