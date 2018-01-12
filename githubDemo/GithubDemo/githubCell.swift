//
//  githubCell.swift
//  GithubDemo
//
//  Created by Prashant Bhandari on 2/18/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class githubCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var forkLabel: UILabel!
    @IBOutlet weak var avatarPhotoLabel: UIImageView!
    
    var repo: GithubRepo! {
        didSet {
            nameLabel.text = repo.name
            ownerLabel.text = "by \(repo.ownerHandle!)"
            descriptionLabel.text = repo.repoDescription
            starLabel.text = String(describing: repo.stars!)
            starLabel.sizeToFit()
            forkLabel.text = String(describing: repo.forks!)
            forkLabel.sizeToFit()
            let avatarURL = URL(string: repo.ownerAvatarURL!)
            avatarPhotoLabel.setImageWith(avatarURL!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
