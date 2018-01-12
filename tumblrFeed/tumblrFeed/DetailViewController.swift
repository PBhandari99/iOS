//
//  DetailViewController.swift
//  tumblrFeed
//
//  Created by Prashant Bhandari on 2/1/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {

    
//    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detalilText: UITextView!
    @IBOutlet weak var photoLabel: UIImageView!
    
    var comment: String?
    var pictureUrlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detalilText.text = comment
        
        let imageUrl = URL(string: pictureUrlString!)
        if let imageUrl = imageUrl {
            photoLabel.setImageWith(imageUrl)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
