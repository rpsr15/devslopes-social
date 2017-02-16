//
//  FeedVC.swift
//  Devslopes Social
//
//  Created by Ravi on 15/02/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit

class FeedVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var tableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 229.0
        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "socialCell") as? SocialCell{
            
            let post = Post()
            if indexPath.row % 3 == 0 {
                post.descriptionText = "abra ka dabra"
            }
            if indexPath.row % 5 == 0 {
                post.postImageURLString = "dfdfdsfdsf"
            }
            post.userName = "rpsr15"
            post.userId = "dfdsfdsfdsfd2112"
            cell.configurePost(post: post)
            return cell
        }
        else{
            return UITableViewCell()
        }
    }

}
