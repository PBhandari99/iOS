//
//  PhotosViewController.swift
//  tumblrFeed
//
//  Created by Prashant Bhandari on 1/31/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit
import AFNetworking


class PhotosViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, UIScrollViewDelegate {
    
    var posts: [NSDictionary] = []
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    let refreshControl = UIRefreshControl()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        self.refreshControl.addTarget(self, action: #selector(PhotosViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        tableView.insertSubview(refreshControl, at: 0)
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        networkRequest()
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        networkRequest()
        refreshControl.endRefreshing()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                self.isMoreDataLoading = true
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        // ... Create the URLRequest (myRequest) ...
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&offset=\(posts.count)")
        let request = URLRequest(url: url!)
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (data, response, error) in
            // Update flag
            self.isMoreDataLoading = false
            
            // ... Use the new data to update the data source ...
            if let data = data {
                if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data, options:[]) as? NSDictionary{
                    let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
//                     adds new data to post array
//                    print(responseFieldDictionary)
                    self.posts += responseFieldDictionary["posts"] as! [NSDictionary]
                }
            }
            self.loadingMoreView!.stopAnimating()
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
        });
        task.resume()
    }
    
    func networkRequest() {
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.tableView.reloadData()
                    }
                }
        });
        task.resume()
    }
//    This method is called right before any segue happens from this ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the index path from the cell that was tapped
        let indexPath = tableView.indexPathForSelectedRow
        // Get the Row of the Index Path and set as index
        let index = indexPath?.row
        // Get in touch with the DetailViewController
        let detailViewController = segue.destination as! DetailViewController
        // Pass on the data to the Detail ViewController by setting it's indexPathRow value
        detailViewController.comment = getCaption(indexForRow: index!)
        let imageUrlString = getPosterViewURL(indexForRow: (indexPath?.row)!) // to get the urlString
        detailViewController.pictureUrlString = imageUrlString
    }
    
    // helper function to get the caption for the tumblr post from the post dictonary
    func getCaption(indexForRow: Int) -> String {
        let captionDict = posts[indexForRow]["reblog"] as! NSDictionary
        var postCaption = captionDict["comment"] as! String
        postCaption = postCaption.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        return postCaption
    }
    
    // returns the url of the image
    func getPosterViewURL(indexForRow: Int) -> String {
        let post = posts[indexForRow]
        let photos = post.value(forKeyPath: "photos") as? [NSDictionary]
//        if let photos = photos{
        return photos![0].value(forKeyPath: "original_size.url") as! String
//            let imageUrl = URL(string: imageUrlString)
//        }
//        return UrlString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell") as! photoCell
//        let post = posts[indexPath.row]
        let summaryText = posts[indexPath.row]["summary"]
        cell.descriptionLabel.text = summaryText as? String
//        let photos = post.value(forKeyPath: "photos") as? [NSDictionary]
//        if let photos = photos{
//            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as! String
//            let imageUrl = URL(string: imageUrlString)
//             if let imageUrl = imageUrl {
//                cell.posterView.setImageWith(imageUrl)
//            }
//        }
        let imageUrlString = getPosterViewURL(indexForRow: indexPath.row) // to get the urlString
        let imageUrl = URL(string: imageUrlString)
        if let imageUrl = imageUrl {
            cell.posterView.setImageWith(imageUrl)
        }
        return cell
    }
}




