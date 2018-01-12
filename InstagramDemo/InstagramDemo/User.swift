//
//  User.swift
//  InstagramDemo
//
//  Created by Prashant Bhandari on 3/15/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit
import Parse

class User: NSObject {
    
    var username: String?
    var password: String?
    var dictionary: NSDictionary?
    
    init(userInfo: NSDictionary) {
        self.username = userInfo["username"] as? String
        self.password = userInfo["password"] as? String
        self.dictionary = userInfo
    }
    
    static let userDidLogoutNotification = "userDidLogout"
    
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let savedUser = defaults.object(forKey: "savedUser") as? Data
                if let savedUser = savedUser {
                    let dictionary = try! JSONSerialization.jsonObject(with: savedUser as Data, options: [])
                    _currentUser = User(userInfo: dictionary as! NSDictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "savedUser")
            }
            else {
                defaults.removeObject(forKey: "savedUser")
            }
            defaults.synchronize()
        }
    }
}
