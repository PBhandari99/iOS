//
//  DetailsViewController.swift
//  twitterDemo
//
//  Created by Prashant Bhandari on 3/4/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit

//protocol tweetChangesViewControllesDelegate: class {
//    func didReweetFavoirtie(tweet: Tweets, index: Int)
//}

class DetailsViewController: UIViewController {

    
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButtonOutlet: UIButton!
    @IBOutlet weak var favoriteButtonOutlet: UIButton!

//    weak var delegate: tweetChangesViewControllesDelegate?
    
    var tweet: Tweets?
    var tweetID: String!
    var retweeted: Bool?
    var favorite: Bool?
    var index: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageLabel.setImageWith((tweet?.user?.profileImageURL)!)
        nameLabel.text = tweet?.user?.name
        screenNameLabel.text = "@" + (tweet?.user?.screenName)!
        postTextLabel.text = tweet?.text
        timeLabel.text = timeParser()
        self.tweetID = tweet?.tweetId
        print(self.tweetID)
        self.retweeted = tweet?.retweeted
        retweetLabel.text = "\((tweet?.retweetCount)!)"
        favoritesLabel.text = "\((tweet?.favoritesCount)!)"
        self.favorite = tweet?.favorite
        if self.retweeted! {
            retweetButtonOutlet.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
        }
        else {
            retweetButtonOutlet.setImage(UIImage(named: "retweet-icon"), for: .normal)
        }
        if self.favorite! {
            favoriteButtonOutlet.setImage(UIImage(named: "favor-icon-1"), for: .normal)
        }
        else {
            favoriteButtonOutlet.setImage(UIImage(named: "favor-icon"), for: .normal)
        }
    }
    
    func timeParser() -> String {
        let formater = DateFormatter()
        formater.dateFormat = "MMMM dd, yyyy 'at' h:mm a"
        formater.amSymbol = "AM"
        formater.pmSymbol = "PM"
        let time = formater.string(from: (tweet?.timeStamp)!)
        return time
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func retweetButton(_ sender: Any) {
        self.retweeted = !self.retweeted!
        tweet?.retweeted = self.retweeted!
        twitterClient.sharedClient?.reTweet(retweeting: self.retweeted!, tweetID: tweetID)
        if self.retweeted! {
            retweetButtonOutlet.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
            tweet?.retweetCount += 1
            retweetLabel.text = "\((tweet?.retweetCount)!)"
        }
        else {
            retweetButtonOutlet.setImage(UIImage(named: "retweet-icon"), for: .normal)
            tweet?.retweetCount -= 1
            retweetLabel.text = "\((tweet?.retweetCount)!)"
        }
    }
    
    @IBAction func favoriteButton(_ sender: Any) {
        self.favorite = !self.favorite!
        tweet?.favorite = self.favorite!
        twitterClient.sharedClient?.favoritePost(favoriting: self.favorite!, tweetID: tweetID)
        if self.favorite! {
            favoriteButtonOutlet.setImage(UIImage(named: "favor-icon-1"), for: .normal)
            tweet?.favoritesCount += 1
            favoritesLabel.text = "\((tweet?.favoritesCount)!)"
        }
        else {
            favoriteButtonOutlet.setImage(UIImage(named: "favor-icon"), for: .normal)
            tweet?.favoritesCount -= 1
            favoritesLabel.text = "\((tweet?.favoritesCount)!)"
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.delegate?.didReweetFavoirtie(tweet: tweet!, index: index)
//    }
}
