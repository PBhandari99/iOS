//
//  twitterClient.swift
//  twitterDemo
//
//  Created by Prashant Bhandari on 2/27/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class twitterClient: BDBOAuth1SessionManager {
    
    static let sharedClient = twitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "BitsWtmE778y9uGkfG1nrImHj", consumerSecret: "lRYjrXXptRdfWC0lhTNdhD2zwzNDuvHo10onRPOiiWkx6cO1d7")
    
    func handleURL(url: URL) {
        let token = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: token, success: { (accessToken: BDBOAuth1Credential?) in
            print("Got the access token")
            self.currentUser(success: { (user: User) in
                User.currentUser = user
            }, failure: { (error :Error) in
                self.loginFailure!(error)
            })
            self.loginSuccess?()
        },
        failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    
    func homeTimeline(ID: NSArray, success: @escaping ([Tweets]) -> (), failure: @escaping (Error) -> ()) {
        var parameters: [String:AnyObject]?
        // this condition is for when the app loads for the first time & doesn't have max_ID or since_ID
        if ID.contains("empty") {
            parameters = nil
        }
        else if ID.contains("since") {
            parameters = ["since_id": ID[1] as AnyObject]
        }
        else if ID.contains("max") {
            parameters = ["max_id": ID[1] as AnyObject]
        }
        get("1.1/statuses/home_timeline.json", parameters: parameters, progress: nil, success: {(task: URLSessionDataTask, respond: Any?) in
            let respondDict = respond as! [NSDictionary]
//            print(respondDict[0])
            let tweetsArray = Tweets.tweetsFromArray(tweetsDictonary: respondDict)
            success(tweetsArray)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func currentUser(success: @escaping (User)->(), failure: @escaping (Error)->()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, respond: Any?) in
            let respondDict = respond as! NSDictionary
            let userAccount = User(dictonary: respondDict)
            success(userAccount)
        }) { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        }
    }
    
    func statues(user: String, success: @escaping ([Tweets])->(), failure: @escaping (Error)->()) {
        let count = "\(10)"
        get("1.1/statuses/user_timeline.json?screen_name=\(user)&count=\(count)", parameters: nil, progress: nil, success: {(task: URLSessionDataTask, respond: Any?) in
            let respondDict = respond as! [NSDictionary]
//            print(respondDict[0])
            let statuses = Tweets.tweetsFromArray(tweetsDictonary: respondDict)
            success(statuses)
        }) {(task: URLSessionDataTask?, error: Error) in
            print("Error fatching statuses: \(error.localizedDescription)")
            failure(error)
        }
    }
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping ()->(), error: @escaping (Error)->()) {
        loginSuccess = success
        loginFailure = error
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterRipOff://oauth"), scope: nil, success: {(requesttoken) in
            let token = requesttoken?.token
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token!)")
            
            UIApplication.shared.open(url!, options: [:], completionHandler: { (success: Bool) in
                print("opened")
            })
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
        })
    }
    
    func logOut() {
        print("tried")
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogOutNoitfication), object: nil)
    }
    
    func reTweet(retweeting: Bool, tweetID: String) {
        var endPoint: String?
        if retweeting {
            endPoint = "retweet"
        }
        else {
            endPoint = "unretweet"
        }
        post("1.1/statuses/\(endPoint!)/\(tweetID).json", parameters: nil, progress: nil,
            success: {
                (task: URLSessionDataTask, response: Any?) in
                print("retweetStatus: \(endPoint!): success")
        },
            failure: { (task: URLSessionDataTask?, error: Error) in
                print("error retwitting: ERROR: \(error)")
        })
    }
    
    func favoritePost(favoriting: Bool, tweetID: String) {
        var endPoint: String?
        if favoriting {
            endPoint = "create"
        }
        else {
            endPoint = "destroy"
        }
        post("1.1/favorites/\(endPoint!).json?id=\(tweetID)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, respond: Any?) in
            print("favoriteStatus: \(endPoint!): success")
        }) { (task :URLSessionDataTask?, error: Error) in
            print("error favoriting: \(error.localizedDescription)")
        }
        
    }
    
    func tweetStatus(status: String) {
        guard let encodedStatus = status.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            print("not status passed")
            return
        }
        post("1.1/statuses/update.json?status=\(encodedStatus)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, respond: Any?) in
            print("status Post success")
        }) { (task: URLSessionDataTask?, error: Error) in
            print("errro occuerd tweeting \(error.localizedDescription)")
        }
    }
    
}
