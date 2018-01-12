//
//  tableViewCell.swift
//  twitterDemo
//
//  Created by Prashant Bhandari on 2/27/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit
import AFNetworking

//protocol tweetDataChangedDelegate: class {
//    func retweetedFromCell(tweet: Tweets, index: Int)
//    func favoritedFromCell(tweet: Tweets, index: Int)
//}

class tableViewCell: UITableViewCell {

    @IBOutlet weak var tweetBy: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
//    weak var delegate: tweetDataChangedDelegate?
    
    var tweetID: String!
    var retweeted: Bool?
    var favorite: Bool?
    
    
    var tweet: Tweets! {
        didSet {
            tweetBy.text = tweet.user?.name
            tweetText.text = tweet.text
            screenName.text = "@\((tweet.user?.screenName)!)"
            tweetImage.setImageWith((tweet.user?.profileImageURL)!)
            timeStamp.text = timePassed(timestamp: tweet.timeStamp!)
            self.tweetID = tweet.tweetId! as String
            self.retweeted = tweet.retweeted
            if self.retweeted! {
                retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
            }
            else {
                retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
            }
            self.favorite = tweet.favorite
            if self.favorite! {
                favoriteButton.setImage(UIImage(named: "favor-icon-1"), for: .normal)
            }
            else {
                favoriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
            }
            retweetsCountLabel.text = "\(tweet.retweetCount)"
            favoriteCountLabel.text = "\(tweet.favoritesCount)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        tweetImage.layer.cornerRadius = 5
        tweetImage.clipsToBounds = true
        // Initialization code
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
    
    // calls the post request to retweet and change the button to show retweeded
    @IBAction func reTweetButton(_ sender: Any) {
        self.retweeted = !self.retweeted!
        tweet.retweeted = self.retweeted!
        if let tweetID = self.tweetID {
            twitterClient.sharedClient?.reTweet(retweeting: self.retweeted!, tweetID:tweetID)
        }
        
        if self.retweeted! {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
            tweet.retweetCount += 1
            retweetsCountLabel.text = "\(tweet.retweetCount)"
            
        }
        else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
            tweet.retweetCount -= 1
            retweetsCountLabel.text = "\(tweet.retweetCount)"
        }
//        self.delegate?.retweetedFromCell(tweet: tweet, index: indexOfCell)
    }
    
    // calls the post request to mark favorite and change the button to show favoiteted
    @IBAction func favoriteButton(_ sender: Any) {
        self.favorite = !self.favorite!
        tweet.favorite = self.favorite!
        if let tweetID = self.tweetID {
            twitterClient.sharedClient?.favoritePost(favoriting: self.favorite!, tweetID: tweetID)
        }
        
        if self.favorite! {
            favoriteButton.setImage(UIImage(named: "favor-icon-1"), for: .normal)
            tweet.favoritesCount += 1
            favoriteCountLabel.text = "\(tweet.favoritesCount)"
        }
        else {
            favoriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
            tweet.favoritesCount -= 1
            favoriteCountLabel.text = "\(tweet.favoritesCount)"
        }
    }
}
