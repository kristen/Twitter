//
//  ProfileCell.swift
//  Twitter
//
//  Created by Kristen on 2/28/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImageView: UIImageView! {
        didSet {
            TweetViewHelper.setImageViewAnimated(userProfileImageView, url: NSURL(string: User.currentUser!.profileImageUrl!)!)
            userProfileImageView.layer.cornerRadius = 6
            userProfileImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var userNameLabel: UILabel! {
        didSet {
            userNameLabel.text = User.currentUser?.name
        }
    }
    @IBOutlet weak var userScreennameLabel: UILabel! {
        didSet {
            userScreennameLabel.text = TweetViewHelper.formattedScreenname(User.currentUser!.screenname!)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
