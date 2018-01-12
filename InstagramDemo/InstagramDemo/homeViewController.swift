//
//  homeViewController.swift
//  InstagramDemo
//
//  Created by Prashant Bhandari on 3/14/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit
import Parse

class homeViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    let vc = UIImagePickerController()
    var posts:  [PFObject]?
    var postImage: UIImage?
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vc.delegate = self
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        
        tableViewOutlet.rowHeight = UITableViewAutomaticDimension
        tableViewOutlet.estimatedRowHeight = 120
        
        getPosts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getPosts()
    }
    
    // queries the database for the posted images and stores to the "posts[PFObject]" array
    func getPosts() {
        let postQuery = PFQuery(className: "Post")
        postQuery.whereKeyExists("image")
        postQuery.includeKey("caption")
        postQuery.order(byDescending: "createdAt")
        postQuery.limit = 20
        postQuery.findObjectsInBackground { (respondArray: [PFObject]?, error: Error?) in
            if respondArray != nil {
                self.posts = respondArray!
                self.tableViewOutlet.reloadData()
            }
            else {
                print("error: \(error?.localizedDescription)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func cameraButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            self.openCamera()
        }))
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { (_) in
            self.openPhotoGallery()
        }
        alertController.addAction(galleryAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.camera
            self.present(vc, animated: true, completion: nil)
        }
        else {
            let alertController = UIAlertController(title: "Alert", message: "Couldnot find Camera", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            //            DispatchQueue.main.sync {}
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // getting the image
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                postImage = editedImage
            dismiss(animated: true, completion: { 
                self.performSegue(withIdentifier: "postImageSegue", sender: nil)
            })
        }
        else {
            print("Didn't get the images")
        }
//        DispatchQueue.main.sync {
//        self.performSegue(withIdentifier: "postImageSegue", sender: nil)
//        }
    }
    
    func openPhotoGallery() {
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(vc, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postImageSegue" {
            let navController = segue.destination as! UINavigationController
            let postImage = navController.topViewController as! PostImageViewController
            postImage.image = self.postImage
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = self.posts {
            return posts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOutlet.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        cell.post = posts?[indexPath.row]
        return cell
    }
    
    // log user out
    @IBAction func logOutButton(_ sender: Any) {
        Authentication.logOut()
    }
}
