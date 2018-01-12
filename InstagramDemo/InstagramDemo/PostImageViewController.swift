//
//  PostImageViewController.swift
//  InstagramDemo
//
//  Created by Prashant Bhandari on 3/16/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit
import MBProgressHUD

class PostImageViewController: UIViewController {

    @IBOutlet weak var postImageLabel: UIImageView!
    @IBOutlet weak var postCaptionTextField: UITextView!
    
    var image: UIImage?
    var caption: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postImageLabel.image = image
        self.postCaptionTextField.clearsOnInsertion = true
//        postCaptionTextField 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Alert!", message: "Are you sure you want to exit", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.caption = postCaptionTextField.text
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Post.postUserImage(image: image, caption: caption) { (success: Bool, error: Error?) in
            if success {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.dismiss(animated: true, completion: nil)
            }
            else {
                print("error while saving photo: \(error)")
                let alertController = UIAlertController(title: "Error", message: "error occured while posting image", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
