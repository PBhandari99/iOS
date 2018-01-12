//
//  PostTableViewCell.swift
//  InstagramDemo
//
//  Created by Prashant Bhandari on 3/16/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit
import Parse

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    var post: PFObject? {
        didSet {
            print("this is image \((post?["image"])!)")
            getImage()
            postImage.image = self.postImage.image
            captionLabel.text = post?["caption"] as? String
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        captionLabel.text = "override func setSelected(_ selected: Bool, animated: Bool) super.setSelected(selected, animated: animated)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func getImage() {
        if let imageFile = post?.value(forKey: "image") {
//            let imageFile = imageFile as! PFFile
            (imageFile as! PFFile).getDataInBackground(block: { (imageData: Data?, error: Error?) in
                    let image = UIImage(data: imageData!)
                if image != nil {
                    self.postImage.image = image
                }
            })
        }
    }

}
