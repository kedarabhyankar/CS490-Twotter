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
        loadTweets()
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        self.loadTweets()
    }
    
    @objc func loadTweets(){
        numberOfTweets = 20
        let apiURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count":numberOfTweets]
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
    
    func loadMoreTweets(){
        let apiURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets = numberOfTweets + 20
        let params = ["count":numberOfTweets]
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if(indexPath.row + 1 == tweetLibrary.count){
            loadMoreTweets()
        }
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
