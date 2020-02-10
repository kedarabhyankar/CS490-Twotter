//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Kedar Abhyankar on 2/9/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    
    var tweetLibrary = [NSDictionary]()
    var numberOfTweets: Int!
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
        myRefreshControl.addTarget(self, action: #selector(loadTweet), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    @objc func loadTweet(){
        let apiURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count":10]
        TwitterAPICaller.client?.getDictionariesRequest(url: apiURL, parameters: params, success: {(tweets:[NSDictionary]) in
            
            self.tweetLibrary.removeAll()
            for tweet in tweets {
                self.tweetLibrary.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: {(Error) in
            print("Could not retrieve tweet!")
        })
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetLibrary[indexPath.row]["user"] as! NSDictionary
        cell.userName.text = user["name"] as? String;
        cell.tweetContent.text = tweetLibrary[indexPath.row]["text"] as? String
       
        let imageURL = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageURL!)
        
        if let imageData = data {
            cell.profileImage.image = UIImage(data: imageData)
        }
        
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetLibrary.count
    }
}
