//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Prashant Bhandari on 1/29/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var navBarFirstPage: UINavigationItem!

    

    var movies: [NSDictionary]?
    var endPoint: String?
    var loadingMoreView:InfiniteScrollActivityView?
    var isMoreDataLoading = false
    let refreshControl = UIRefreshControl()
    var page: Int = 2
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if endPoint == "now_playing" {
            navBarFirstPage.title = "Now Playing"
        }
        else if endPoint == "top_rated" {
            navBarFirstPage.title = "Top Rated"
        }
        
        errorView.isHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        //loading animation
        MBProgressHUD.showAdded(to: self.view, animated: true)
        networkRequest() // call for the http call
        MBProgressHUD.hide(for: self.view, animated: true)
        //pull to refresh
        refreshControl.tintColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Handle scroll behavior here
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()

                // ... Code to load more results ...
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        
        // ... Create the NSURLRequest (myRequest) ...
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endPoint!)?api_key=\(apiKey)&page=\(page)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (data, response, error) in
            
            // Update flag
            self.isMoreDataLoading = false
            
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
            
            // ... Use the new data to update the data source ...
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    let responseData = dataDictionary["results"] as? [NSDictionary]
                    if let responseData = responseData {
                        self.movies! += responseData as [NSDictionary]
                        self.page += 1
                    }
                }
            }
            else {
                self.errorView.isHidden = false
            }
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
        });
        task.resume()
    }
    
    // HTTP call, takes no argument and doesn't return anything
    func networkRequest(){
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endPoint!)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
//                self.errorView.isHidden = true
            }
            else{
                self.errorView.isHidden = false
                
            }
        }
        task.resume()
    }
    
    //    This method is called right before any segue happens from this ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the index path from the cell that was tapped
        let indexPath = tableView.indexPathForSelectedRow
        // Get the Row of the Index Path and set as index
        let index = indexPath?.row
        // Get in touch with the DetailViewController; downcast the viewcontroller.
        let detailsViewController = segue.destination as! detailsViewController
        // Pass on the data to the Detail ViewController by setting it's indexPathRow value
        let movie = movies![index!]
        
        let title = movie["title"] as! String
        detailsViewController.movieTitle = title
        
        let releaseDate = movie["release_date"] as! String
        detailsViewController.releaseDate = releaseDate
        
        let overview = movie["overview"] as! String
        detailsViewController.textDetails = overview
        
        let rating = movie["vote_average"] as! Float
        detailsViewController.rating = rating
        
        let posterPath = movie["poster_path"] as! String
        let baseURL = "https://image.tmdb.org/t/p/w500/"
        let imageURLString = baseURL + posterPath
        detailsViewController.imageUrlString = imageURLString
        
    }

    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        networkRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        
        let movie = movies?[indexPath.row]
        let title = movie?["title"] as! String
        let overview = movie?["overview"] as! String
        let posterPath = movie?["poster_path"] as! String
        let baseURL = "https://image.tmdb.org/t/p/w500/"
        let imageURL = NSURL(string: baseURL + posterPath)
        
        // writing to the lable in the table cell
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterView.setImageWith(imageURL as! URL)
        cell.selectionStyle = .none

        return cell
    }
}
