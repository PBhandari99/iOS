//
//  tweets.swift
//  twitterDemo
//
//  Created by Prashant Bhandari on 2/27/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit

class Tweets: NSObject {
    var text: String?
    var user: User?
    var retweetCount: Int = 0
    var timeStamp: Date?
    var favoritesCount: Int = 0
    var tweetId: String?
    var retweeted: Bool = false
    var favorite: Bool = false
    
    init(dictonary: NSDictionary) {
        self.text = dictonary["text"] as? String
        self.retweetCount = (dictonary["retweet_count"] as? Int) ?? 0
        self.favoritesCount = (dictonary["favorite_count"] as? Int) ?? 0
        let timeStampString = dictonary["created_at"] as? String
        if let timeStampString = timeStampString{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.date(from: timeStampString)
        }
        self.tweetId = dictonary["id_str"] as? String
        let userDictonary = dictonary["user"] as! NSDictionary
        self.user = User(dictonary: userDictonary)
        self.retweeted = (dictonary["retweeted"] as? Bool) ?? false
        self.favorite = (dictonary["favorited"] as? Bool) ?? false
    }
    
    class func tweetsFromArray(tweetsDictonary: [NSDictionary]) -> [Tweets] {
        var tweets = [Tweets]()
        for dictonary in tweetsDictonary {
            let tweet = Tweets(dictonary: dictonary)
            tweets.append(tweet)
        }
        return tweets
    }
}
