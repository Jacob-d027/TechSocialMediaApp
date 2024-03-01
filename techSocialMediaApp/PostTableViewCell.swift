//
//  PostTableViewCell.swift
//  techSocialMediaApp
//
//  Created by Jacob Davis on 2/7/24.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numOfLikesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(for post: Post) {
        titleLabel.text = post.title
        numOfLikesLabel.text = String(post.likes)
        dateLabel.text = post.createdDate
        userNameLabel.text = post.authorUserName
        bodyTextLabel.text = post.body
        commentsLabel.text = "Comments: \(post.numComments)"
    }
}
