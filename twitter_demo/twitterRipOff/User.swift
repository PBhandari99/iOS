//
//  user.swift
//  twitterDemo
//
//  Created by Prashant Bhandari on 2/27/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var profileImageURL: URL?
    var backgroundImageURL: URL?
    var screenName: String?
    var followers: Int?
    var following: Int?
    var noOfPosts: Int?
    var dictonary: NSDictionary?
    
    init(dictonary: NSDictionary) {
        self.name = dictonary["name"] as? String
        let backgroundImageURLString = dictonary["profile_banner_url"] as? String
        if let backgroundImageURLString = backgroundImageURLString {
            self.backgroundImageURL = URL(string: backgroundImageURLString)
        }
        let profileImageURLString = dictonary["profile_image_url_https"] as? String
        if let profileImageURLString = profileImageURLString {
            self.profileImageURL = URL(string: profileImageURLString)
        }
        self.screenName = dictonary["screen_name"] as? String
        self.followers = dictonary["followers_count"] as? Int
        self.following = dictonary["friends_count"] as? Int
        self.noOfPosts = dictonary["statuses_count"] as? Int
        self.dictonary = dictonary
    }
    
    static let userDidLogOutNoitfication = "userDidLogOut"
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                
                let userData = defaults.object(forKey: "currentUserData") as? Data
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: [])
                    _currentUser = User(dictonary: dictionary as! NSDictionary)
                }
            }
            
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictonary!, options: [])
                
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}


