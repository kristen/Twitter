//
//  UserProfileViewController.swift
//  Twitter
//
//  Created by Kristen on 2/24/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    private var user: User!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView! {
        didSet {
            userProfileImageView.layer.cornerRadius = 6
            userProfileImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var profileImageBoarderView: UIView! {
        didSet {
            profileImageBoarderView.layer.cornerRadius = 6
            profileImageBoarderView.clipsToBounds = true
        }
    }
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScreennameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var numberOfTweetsLabel: UILabel!
    @IBOutlet weak var numberOfFavoritesLabel: UILabel!
    @IBOutlet weak var numberOfFollowersLabel: UILabel!
    @IBOutlet weak var followingButton: UIButton! {
        didSet {
            followingButton.layer.cornerRadius = 6
            followingButton.clipsToBounds = true
            followingButton.titleEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = user.name
        
        updateUI()
    }

    
    func setUser(user: User) {
        self.user = user
    }
    
    
    func updateUI() {
        TweetViewHelper.setUser(user, forUserProfileImageView: userProfileImageView, userNameLabel: userNameLabel, andScreennameLabel: userScreennameLabel)
        

        TweetViewHelper.setImageViewAnimated(backgroundImageView, url: NSURL(string: user.backgroundImageUrl!)!)
        descriptionLabel.text = user.tagline
        locationLabel.text = user.location
        
        numberOfTweetsLabel.attributedText = TweetViewHelper.attributedStringWithBoldText("\(user.statusesCount!)", restOfText: " TWEETS")
        numberOfFavoritesLabel.attributedText = TweetViewHelper.attributedStringWithBoldText("\(user.favoritesCount!)", restOfText: " FAVORITES")
        numberOfFollowersLabel.attributedText = TweetViewHelper.attributedStringWithBoldText("\(user.followersCount!)", restOfText: " FOLLOWERS")
        
        if user.following! {
            followingButton.setTitle("Following", forState: .Normal)
        } else {
            followingButton.setTitle("Follow", forState: .Normal)
        }
    }
}
