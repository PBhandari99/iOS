//
//  profileViewController.swift
//  twitterDemo
//
//  Created by Prashant Bhandari on 3/5/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit

class profileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var profileImageLabel: UIImageView!
    @IBOutlet weak var backgoundImageLabel: UIImageView!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var noOfTweetsLabel: UILabel!
    @IBOutlet weak var noOfFollowingLabel: UILabel!
    @IBOutlet weak var noOfFollowersLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    
    var user: User?
    var tweets: [Tweets]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // cell expands as per need
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        if user?.name == "Prashant Bhandari" {
            navBar.title = "me"
        }
        else {
            navBar.title = user?.name
        }
        nameLabel.text = user?.name
        screenNameLabel.text = "@"+(user?.screenName)!
        profileImageLabel.setImageWith((user?.profileImageURL)!)
        if (user?.backgroundImageURL) != nil {
         backgoundImageLabel.setImageWith((user?.backgroundImageURL)!)
        }
        noOfFollowingLabel.text = "\((user?.following)!)"
        noOfFollowersLabel.text = "\((user?.followers)!)"
        noOfTweetsLabel.text = "\((user?.noOfPosts)!)"
        
        // tweets for the table view
        twitterClient.sharedClient?.statues(user: "\((user?.screenName)!)", success: { (tweets :[Tweets]) in
            self.tweets = tweets
            print((self.tweets?.count)!)
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let composeView = navController.topViewController as! ComposeTweetViewController
        composeView.currentUser = user
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets {
            return tweets.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        cell.tweet = tweets?[indexPath.row]
        return cell
    } 
}
