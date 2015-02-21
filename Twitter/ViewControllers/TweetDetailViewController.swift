//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Kristen on 2/20/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    @IBOutlet weak var userProfileImageView: UIImageView!
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
        
        userProfileImageView.layer.cornerRadius = 6
        userProfileImageView.clipsToBounds = true
        
        navigationItem.title = "Tweet"
        
        updateUI()
    }

    func setTweet(tweet: Tweet) {
        self.tweet = tweet
    }
    
    func updateUI() {
        var originalTweet: Tweet
        if let retweetedStatus = tweet.retweetedStatus {
            originalTweet = retweetedStatus
            
            retweetUserImageView.image = UIImage(named: "retweet")
            
            if let user = tweet.user {
                retweetUserLabel.text = "\(user.name!) retweeted"
            }
            
        } else {
            originalTweet = tweet
            
            retweetUserLabel.text = nil
            retweetUserImageView.image = nil
        }

        
        if let user = originalTweet.user {
            
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
        
        retweetCountLabel.attributedText = attributedStringWithBoldText("\(originalTweet.retweetCount!)", restOfText: " RETWEETS")
        
        favoriteCountLabel.attributedText = attributedStringWithBoldText("\(originalTweet.favoriteCount!)", restOfText: " FAVORITES")
        
        if originalTweet.favorited! {
            favoriteButton.setImage(UIImage(named: "favorite_on"), forState: .Normal)
        } else {
            favoriteButton.setImage(UIImage(named: "favorite"), forState: .Normal)
        }
        
        if originalTweet.retweeted! {
            retweetButton.setImage(UIImage(named: "retweet_on"), forState: .Normal)
        } else {
            retweetButton.setImage(UIImage(named: "retweet"), forState: .Normal)
        }

        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        if let createdAt = originalTweet.createdAt {
            tweetCreatedAtLabel.text = dateFormatter.stringFromDate(createdAt)
        }
        
        tweetTextLabel.text = originalTweet.text
    }
    
    func attributedStringWithBoldText(boldText: String, restOfText: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(boldText) \(restOfText)")
        
        attributedString.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(13), NSForegroundColorAttributeName: UIColor.blackColor()], range: NSRange(location: 0, length: countElements(boldText)))
        
        return attributedString
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
        
        if tweet.favorited! {
            TwitterClient.sharedInstance.unfavorite(tweet.id!, completion: { (tweet, error) -> () in
                if tweet != nil {
                    self.tweet = tweet
                    self.updateUI()
                } else {
                    println("error retweeting")
                }
            })

        } else {
            TwitterClient.sharedInstance.favorite(tweet.id!, completion: { (tweet, error) -> () in
                if tweet != nil {
                    self.tweet = tweet
                    self.updateUI()
                } else {
                    println("error retweeting")
                }
            })
        }
    }
}
