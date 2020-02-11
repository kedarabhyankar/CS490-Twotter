//
//  TweetCell.swift
//  Twitter
//
//  Created by Kedar Abhyankar on 2/9/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    var favorited:Bool = false
    var tweetID: Int = -1;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func retweetFunctionality(_ sender: Any) {
        TwitterAPICaller.client?.retweetTweet(tweetId: tweetID, success: {
            self.setRetweeted(true)
        }, failure: {(error) in
            print("Error in retweeting! \(error), here!")
        })
    }
    
    @IBAction func favoriteFunctionality(_ sender: Any) {
        let toBeFavorited = !favorited;
        if(toBeFavorited){
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetID, success: {
                self.setFavorited(true)
            }, failure: {
                (error) in print("Did not succeed in favoriting tweet! \(error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetID, success: {
                self.setFavorited(false)
            }, failure: {
                (error) in print("Did not succeed in unfavoriting tweet! \(error)")
            })
        }
        
    }
    
    func setFavorited(_ isFavorited:Bool){
        self.favorited = isFavorited
        if(self.favorited){
            favButton.setImage(UIImage(named:"favor-icon-red"), for: UIControl.State.normal)
        } else {
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweeted(_ isRetweeted:Bool){
        if(isRetweeted){
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        } else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for:UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
    
    
    
}
