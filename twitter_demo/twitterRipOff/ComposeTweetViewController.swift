//
//  ComposeTweetViewController.swift
//  twitterDemo
//
//  Created by Prashant Bhandari on 3/7/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var photoLabel: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var textField: UITextView!
    
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        textField.delegate = self
        nameLabel.text = (currentUser?.name)!
        screenNameLabel.text = "@"+"\((currentUser?.screenName)!)"
        photoLabel.setImageWith((currentUser?.profileImageURL)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    @IBAction func doneComposing(_ sender: Any) {
        if let statusTest = self.textField.text {
            twitterClient.sharedClient?.tweetStatus(status: statusTest)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func compositionCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
