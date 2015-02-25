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
    @IBOutlet weak var userProfileImageView: UIImageView! {
        didSet {
            userProfileImageView.layer.cornerRadius = 6
            userProfileImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScreennameLabel: UILabel!

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
    }
}
