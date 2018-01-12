//
//  ProfileTableViewCell.swift
//  twitterDemo
//
//  Created by Prashant Bhandari on 3/7/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postPhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweetID: String!
    var retweeted: Bool?
    var favorite: Bool?
    
    
    var tweet: Tweets! {
        didSet {
            nameLabel.text = tweet.user?.name
            postPhoto.setImageWith((tweet.user?.profileImageURL)!)
            screenNameLabel.text = "@\((tweet.user?.screenName)!)"
            timeLabel.text = timePassed(timestamp: tweet.timeStamp!)
            postTextLabel.text = tweet.text
            retweetLabel.text = "\(tweet.retweetCount)"
            favoriteLabel.text = "\(tweet.favoritesCount)"
            self.tweetID = tweet.tweetId
            self.retweeted = tweet.retweeted
            self.favorite = tweet.favorite
            if self.retweeted! {
                retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
            }
            else {
                retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
            }
            if self.favorite! {
                favoriteButton.setImage(UIImage(named: "favor-icon-1"), for: .normal)
            }
            else {
                favoriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postPhoto.layer.cornerRadius = 4
        postPhoto.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func timePassed(timestamp: Date) -> String {
        let interval = timestamp.timeIntervalSinceNow
        
        if interval < 60 * 60 * 24 {
            let seconds = -Int(interval.truncatingRemainder(dividingBy: 60))
            let minutes = -Int((interval / 60).truncatingRemainder(dividingBy: 60))
            let hours = -Int((interval / 3600))
            
            let result = (hours == 0 ? "" : "\(hours)h ") + (minutes == 0 ? "" : "\(minutes)m ") + (seconds == 0 ? "" : "\(seconds)s")
            return result
        } else {
            let formatter: DateFormatter = {
                let f = DateFormatter()
                f.dateFormat = "EEE/MMM/d"
                return f
            }()
            return formatter.string(from: timestamp as Date)
        }
    }
    
    @IBAction func retweetButtonOnTap(_ sender: Any) {
        self.retweeted = !self.retweeted!
        tweet.retweeted = self.retweeted!
        twitterClient.sharedClient?.reTweet(retweeting: self.retweeted!, tweetID: self.tweetID)
        if self.retweeted! {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
            tweet.retweetCount += 1
            retweetLabel.text = "\(tweet.retweetCount)"
        }
        else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
            tweet.retweetCount -=  1
            retweetLabel.text = "\(tweet.retweetCount)"
        }
    }

    @IBAction func favoriteButtonOnTap(_ sender: Any) {
        self.favorite = !self.favorite!
        tweet.favorite = self.favorite!
        twitterClient.sharedClient?.favoritePost(favoriting: self.favorite!, tweetID: tweetID)
        if self.favorite! {
            favoriteButton.setImage(UIImage(named: "favor-icon-1"), for: .normal)
            tweet.favoritesCount += 1
            favoriteLabel.text = "\(tweet.favoritesCount)"
        }
        else {
            favoriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
            tweet.favoritesCount -= 1
            favoriteLabel.text = "\(tweet.favoritesCount)"
        }
    }
}
