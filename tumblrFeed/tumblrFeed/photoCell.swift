//
//  photoCell.swift
//  tumblrFeed
//
//  Created by Prashant Bhandari on 2/1/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit

class photoCell: UITableViewCell {
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
