//
//  TweetCell.swift
//  Twitter
//
//  Created by Kristen on 2/17/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

protocol TweetCellDelegate: class {
    func tweetCell(tweetCell: TweetCell, didReplyToTweet replyTweet: Tweet)
}

class TweetCell: UITableViewCell {
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScreennameLabel: UILabel!
    @IBOutlet weak var tweetCreatedAtLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    private var tweet: Tweet!
    weak var delegate: TweetCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
        
        userProfileImageView.layer.cornerRadius = 6
        userProfileImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTweet(tweet: Tweet) {
        self.tweet = tweet
        if let user = tweet.user {
            
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
        
        retweetCountLabel.text = "\(tweet.retweetCount!)"
        
        favoriteCountLabel.text = "\(tweet.favoriteCount!)"
        
        if tweet.favorited! {
            favoriteButton.setImage(UIImage(named: "favorite_on"), forState: .Normal)
        } else {
            favoriteButton.setImage(UIImage(named: "favorite"), forState: .Normal)
        }
        
        if tweet.retweeted! {
            retweetButton.setImage(UIImage(named: "retweet_on"), forState: .Normal)
        } else {
            retweetButton.setImage(UIImage(named: "retweet"), forState: .Normal)
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        if let createdAt = tweet.createdAt {
            tweetCreatedAtLabel.text = dateFormatter.stringFromDate(createdAt)
        }
        
        tweetTextLabel.text = tweet.text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
        
    }
    
    @IBAction func onReply() {
        println("replied")
        
        delegate?.tweetCell(self, didReplyToTweet: tweet)
    }
    
    @IBAction func onRetweet() {
        println("retweeted")
        
        TwitterClient.sharedInstance.retweet(tweet.id!, completion: { (tweet, error) -> () in
            if tweet != nil {
                
                self.setTweet(tweet!)
                
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
                    self.setTweet(tweet!)
                } else {
                    println("error retweeting")
                }
            })
            
        } else {
            TwitterClient.sharedInstance.favorite(tweet.id!, completion: { (tweet, error) -> () in
                if tweet != nil {
                    self.setTweet(tweet!)
                } else {
                    println("error retweeting")
                }
            })
        }

    }
    
}
