//
//  RepositoryTableViewCell.swift
//  GithubDemo
//
//  Created by Andrew Montgomery on 9/3/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        repoNameLabel.preferredMaxLayoutWidth = repoNameLabel.frame.size.width
        descriptionLabel.preferredMaxLayoutWidth = descriptionLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
