//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Kristen on 2/20/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

protocol ComposeTweetViewControllerDelegate : class {
    func composeTweetViewController(composeTweetViewController: ComposeTweetViewController, didTweet tweet: Tweet)
}

class ComposeTweetViewController: UIViewController {
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScreennameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var characterCountLabel: UILabel!
    private var replyTweet: Tweet?
    weak var delegate: ComposeTweetViewControllerDelegate?
    private var placeholderText = "What's happening?"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tweetTextView.delegate = self
        
        userProfileImageView.layer.cornerRadius = 6
        userProfileImageView.clipsToBounds = true
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "onCancel")
        navigationController?.navigationBar.tintColor = twitterBlue
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()

        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tweet", style: .Plain, target: self, action: "onTweet")
        
        if let replyTweetScreenname = replyTweet?.user?.screenname {
            tweetTextView.textColor = UIColor.blackColor()
            tweetTextView.text = "@\(replyTweetScreenname) "
            characterCountLabel.text = "\(140 - countElements(tweetTextView.text))"
            tweetTextView.becomeFirstResponder()
        } else {
            placeholderTweetTextView()
        }
        
        updateUI()
    }

    func setReplyTweet(tweet: Tweet?) {
        self.replyTweet = tweet
    }
    
    func onCancel() {
        // TODO: posibly send notification to make the parent view controller dismiss
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onTweet() {
        println("new tweet text")
        println(tweetTextView.text)
        
        if countElements(tweetTextView.text) > 0 && tweetTextView.text != placeholderText && tweetTextView.textColor != UIColor.lightGrayColor() {
            var params: [String: String] = [:]
            if let replyTweet = replyTweet {
                params.updateValue("\(replyTweet.id)", forKey: "reply_id")
            }
            TwitterClient.sharedInstance.tweetWithParams(tweetTextView.text, additionalParams: params, completion: { (tweet, error) -> () in
                if let tweet = tweet {
                    println(tweet)
                    // posibly do something to append it to current timeline
                    self.delegate?.composeTweetViewController(self, didTweet: tweet)
                } else {
                    println("error posting tweet")
                }
            })
            
            onCancel()
        }
    }
    
    func updateUI() {
        if let user = User.currentUser {
            TweetViewHelper.setUser(user, forUserProfileImageView: userProfileImageView, userNameLabel: userNameLabel, andScreennameLabel: userScreennameLabel)
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
        tweetTextView.text = placeholderText
        tweetTextView.textColor = UIColor.lightGrayColor()
    }
    
    func textViewDidChange(textView: UITextView) {
        characterCountLabel.text = "\(140 - countElements(textView.text))"
    }
}
