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
    func tweetCell(tweetCell: TweetCell, showProfileForUser user: User?)
}

class TweetCell: UITableViewCell {
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
    weak var delegate: TweetCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTweet(tweet: Tweet) {
        self.tweet = tweet
        
        var originalTweet: Tweet = TweetViewHelper.getOriginalTweetFrom(tweet, updateRetweetUserImage: retweetUserImageView, andRetweetUserLabel: retweetUserLabel)
        
        if let user = originalTweet.user {
            TweetViewHelper.setUser(user, forUserProfileImageView: userProfileImageView, userNameLabel: userNameLabel, andScreennameLabel: userScreennameLabel)
        }
        
        retweetCountLabel.text = "\(originalTweet.retweetCount!)"
        
        favoriteCountLabel.text = "\(originalTweet.favoriteCount!)"
        
        TweetViewHelper.updateButtonImage(favoriteButton, forState: originalTweet.favorited!, withOnImageNamed: "favorite_on", orOffImageName: "favorite")
        
        TweetViewHelper.updateButtonImage(retweetButton, forState: originalTweet.retweeted!, withOnImageNamed: "retweet_on", orOffImageName: "retweet")
        
        
        if let createdAt = originalTweet.createdAt {
            let timeSinceNowFormatter = TimeSinceNowFormatter()
            tweetCreatedAtLabel.text = timeSinceNowFormatter.formattedAsTimeAgo(createdAt)
        }
        
        tweetTextLabel.text = originalTweet.text
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
        
        TwitterClient.sharedInstance.favorite(tweet.id!, favorite: tweet.favorited!, completion: { (tweet, error) -> () in
            if tweet != nil {
                self.setTweet(tweet!)
            } else {
                println("error favoriting")
            }
        })
    }
    
    func didTapUserProfileImage(guesture: UITapGestureRecognizer) {
        println("did tap user profile image")
        
        
        delegate?.tweetCell(self, showProfileForUser: TweetViewHelper.getOriginalTweetFrom(tweet).user)
    }
}
