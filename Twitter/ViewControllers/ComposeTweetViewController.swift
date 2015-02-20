//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Kristen on 2/20/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScreennameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tweetTextView.delegate = self
        
        userProfileImageView.layer.cornerRadius = 6
        userProfileImageView.clipsToBounds = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "onCancel")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tweet", style: .Plain, target: self, action: "onTweet")
        
        placeholderTweetTextView()
        
        updateUI()
    }

    func onCancel() {
        // TODO: posibly send notification to make the parent view controller dismiss
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onTweet() {
        println("new tweet text")
        println(tweetTextView.text)
        TwitterClient.sharedInstance.tweetWithParams(tweetTextView.text, completion: { (responseObject, error) -> () in
            if responseObject != nil {
                println(responseObject)
                // posibly do something to append it to current timeline
            } else {
                println("error posting tweet")
            }
        })
        onCancel()
    }
    
    func updateUI() {
        if let user = User.currentUser {
            userProfileImageView.contentMode = UIViewContentMode.ScaleAspectFit
            
            if let imageURL = user.profileImageUrl {
                let url = NSURL(string: imageURL)
                userProfileImageView.setImageWithURLRequest(NSMutableURLRequest(URL: url!), placeholderImage: nil, success: { (request, response, image) -> Void in
                    self.userProfileImageView.image = image
                    if (request != nil && response != nil) {
                        self.userProfileImageView.alpha = 0.0
                        UIView.animateWithDuration(1.0, animations: { () -> Void in
                            self.userProfileImageView.alpha = 1.0
                        })
                    }
                    }, failure: nil)
            }
            
            userNameLabel.text = user.name
            
            userScreennameLabel.text = "@\(user.screenname!)"
        }
    }
    
}

extension ComposeTweetViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(textView: UITextView) {
        if tweetTextView.textColor == UIColor.lightGrayColor() {
            tweetTextView.text = nil
            tweetTextView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if tweetTextView.text.isEmpty {
            placeholderTweetTextView()
        }
    }
    
    func placeholderTweetTextView() {
        tweetTextView.text = "What's happening?"
        tweetTextView.textColor = UIColor.lightGrayColor()
    }
}
