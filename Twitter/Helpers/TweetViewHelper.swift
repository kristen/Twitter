//
//  TweetViewHelper.swift
//  Twitter
//
//  Created by Kristen on 2/21/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

class TweetViewHelper: NSObject {
    
    class func setUser(user: User, forUserProfileImageView userProfileImageView: UIImageView, userNameLabel: UILabel, andScreennameLabel userScreennameLabel: UILabel) {
        setProfileImageView(userProfileImageView, user: user)
        
        userNameLabel.text = user.name
        
        userScreennameLabel.text = formattedScreenname(user.screenname!)

    }
   
    class func getOriginalTweetFrom(tweet: Tweet, updateRetweetUserImage retweetUserImageView: UIImageView, andRetweetUserLabel retweetUserLabel: UILabel) -> Tweet {
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
        return originalTweet
    }
    
    
    class func setProfileImageView(imageView: UIImageView, user: User) {
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        if let imageURL = user.profileImageUrl {
            let url = NSURL(string: imageURL)
            imageView.setImageWithURLRequest(NSMutableURLRequest(URL: url!), placeholderImage: nil, success: { (request, response, image) -> Void in
                imageView.image = image
                if (request != nil && response != nil) {
                    imageView.alpha = 0.0
                    UIView.animateWithDuration(1.0, animations: { () -> Void in
                        imageView.alpha = 1.0
                    })
                }
                }, failure: nil)
        }

    }
    
    class func formattedScreenname(screenname: String) -> String {
        return "@\(screenname)"
    }
    
    class func attributedStringWithBoldText(boldText: String, restOfText: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(boldText) \(restOfText)")
        
        attributedString.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(13), NSForegroundColorAttributeName: UIColor.blackColor()], range: NSRange(location: 0, length: countElements(boldText)))
        
        return attributedString
    }
    
    class func updateButtonImage(button: UIButton, forState state: Bool, withOnImageNamed onImageName: String, orOffImageName offImageName: String) {
        if state {
            button.setImage(UIImage(named: onImageName), forState: .Normal)
        } else {
            button.setImage(UIImage(named: offImageName), forState: .Normal)
        }
    }
}
