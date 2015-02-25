//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Kristen on 2/20/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    @IBOutlet weak var userProfileImageView: UIImageView! {
        didSet {
            userProfileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "didTapUserProfileImage:"))
            let recognizer = UITapGestureRecognizer(target: self, action: "didTapUserProfileImage:")
            recognizer.numberOfTapsRequired = 1
            recognizer.numberOfTouchesRequired = 1
            userProfileImageView.addGestureRecognizer(recognizer)
            userProfileImageView.userInteractionEnabled = true
            
            userProfileImageView.layer.cornerRadius = 6
            userProfileImageView.clipsToBounds = true
        }
    }

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScreennameLabel: UILabel!
    @IBOutlet weak var tweetCreatedAtLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetUserLabel: UILabel!
    @IBOutlet weak var retweetUserImageView: UIImageView!
    private var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
        
        navigationItem.title = "Tweet"
        
        updateUI()
    }

    func setTweet(tweet: Tweet) {
        self.tweet = tweet
    }
    
    func updateUI() {
        var originalTweet: Tweet = TweetViewHelper.getOriginalTweetFrom(tweet, updateRetweetUserImage: retweetUserImageView, andRetweetUserLabel: retweetUserLabel)
        
        if let user = originalTweet.user {
            TweetViewHelper.setUser(user, forUserProfileImageView: userProfileImageView, userNameLabel: userNameLabel, andScreennameLabel: userScreennameLabel)
        }
        
        retweetCountLabel.attributedText = TweetViewHelper.attributedStringWithBoldText("\(originalTweet.retweetCount!)", restOfText: " RETWEETS")
        
        favoriteCountLabel.attributedText = TweetViewHelper.attributedStringWithBoldText("\(originalTweet.favoriteCount!)", restOfText: " FAVORITES")
        
        TweetViewHelper.updateButtonImage(favoriteButton, forState: originalTweet.favorited!, withOnImageNamed: "favorite_on", orOffImageName: "favorite")
        
        TweetViewHelper.updateButtonImage(retweetButton, forState: originalTweet.retweeted!, withOnImageNamed: "retweet_on", orOffImageName: "retweet")
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        if let createdAt = originalTweet.createdAt {
            tweetCreatedAtLabel.text = dateFormatter.stringFromDate(createdAt)
        }
        
        tweetTextLabel.text = originalTweet.text
    }
    
    @IBAction func onReply() {
        println("replied")
        
        let composeTweetViewController = ComposeTweetViewController(nibName: "ComposeTweetViewController", bundle: nil)
        composeTweetViewController.setReplyTweet(tweet)
        navigationController?.presentViewController(UINavigationController(rootViewController: composeTweetViewController), animated: true, completion: nil)
    }
    
    @IBAction func onRetweet() {
        println("retweeted")
        
        TwitterClient.sharedInstance.retweet(tweet.id!, completion: { (tweet, error) -> () in
            if tweet != nil {
                self.tweet = tweet
                self.updateUI()
            } else {
                println("error retweeting")
            }
        })
    }
    
    @IBAction func onFavorite() {
        println("favorited")
        
        TwitterClient.sharedInstance.favorite(tweet.id!, favorite: tweet.favorited!, completion: { (tweet, error) -> () in
            if tweet != nil {
                self.tweet = tweet
                self.updateUI()
            } else {
                println("error favoriting")
            }
        })
    }
    
    func didTapUserProfileImage(gesture: UITapGestureRecognizer) {
        println("did tap user profile image on tweet detail view")
        
        let userProfileViewController = UserProfileViewController(nibName: "UserProfileViewController", bundle: nil)
        userProfileViewController.setUser(TweetViewHelper.getOriginalTweetFrom(tweet).user!)
        navigationController?.pushViewController(userProfileViewController, animated: true)
    }
}
