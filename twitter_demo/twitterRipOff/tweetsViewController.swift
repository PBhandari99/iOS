//
//  tweetsViewController.swift
//  twitterDemo
//
//  Created by Prashant Bhandari on 2/27/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit

class tweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweets]?
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    var maxID: String?
    var sinceID: String?
    var idArray: [String]?
    var user: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        // pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        idArray = ["empty"]
        twitterClient.sharedClient?.homeTimeline(ID: idArray! as NSArray, success: { (tweets: [Tweets]) in
            self.tweets = tweets
            self.tableView.reloadData()
            print("Retweeted: \(tweets[0].retweeted)")
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        })
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        // for the profile view contorller
        twitterClient.sharedClient?.currentUser(success: { (user: User) in
            self.user = user
        }, failure: { (error: Error) in
            print("error getting the user info: \(error.localizedDescription)")
        })
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        let tweet = tweets?[0]
        sinceID = tweet?.tweetId
        if let sinceID = self.sinceID {
            idArray = ["since", sinceID]
            print(idArray!)
            twitterClient.sharedClient?.homeTimeline(ID: idArray! as NSArray, success: { (tweets :[Tweets]) in
                print("successful call")
                self.tweets = (tweets + self.tweets!)
                // Reload the tableView now that there is new data
                self.tableView.reloadData()
                
                // Tell the refreshControl to stop spinning
                refreshControl.endRefreshing()
            }, failure: { (error :Error) in
                print("error: \(error.localizedDescription)")
            })
        }
        else {
            print("error getting the tweetId for pull to refresh")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results(scrollOffsetThrashold)
            // tableView.bounds.size.height is the size of one screen length and tableView.contentSize.height is the whole scroll view.
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThrashold = scrollViewContentHeight - tableView.bounds.size.height
             // When the user has scrolled past the threshold, start requesting.
            // scrollView.contentOffset.y is how far the view is scrolled.
            if (scrollView.contentOffset.y > scrollOffsetThrashold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        let tweet = tweets?[(tweets?.count)!-1]
        maxID = tweet?.tweetId
        print(maxID!)
        idArray = ["max", maxID!]
        twitterClient.sharedClient?.homeTimeline(ID: idArray! as NSArray, success: { (tweets: [Tweets]) in
            self.tweets! += tweets as [Tweets]
            self.isMoreDataLoading = false
            self.loadingMoreView!.stopAnimating()
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        })
    }
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        twitterClient.sharedClient?.logOut()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! tableViewCell
        cell.tweet = tweets?[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsView" {
            let indexPath = tableView.indexPathForSelectedRow
            let index = indexPath?.row
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.tweet = tweets?[index!]
            detailsVC.index = index
        }
        else if segue.identifier == "myProfileView" {
            let navController = segue.destination as! UINavigationController
            let profileView = navController.topViewController as! profileViewController
            profileView.user = self.user
        }
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        if self.tweets != nil {
            self.tableView.reloadData()
        }
    }
}
