//
//  TwitterClient.swift
//  Twitter
//
//  Created by Kristen on 2/15/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

let kTwitterConsumerKey = "g5eGUNtmGb07a0Ozxhbih9FjJ"
let kTwitterConsumerSecret = "l4jtKchHoF1pTpJzVHh1AaTH0UdhuEc6UKzHov6JHrkKLe4zCN"
let kTwitterBaseUrl = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    // http://stackoverflow.com/questions/24024549/dispatch-once-singleton-model-in-swift
    class var sharedInstance: TwitterClient {

        struct Singleton {
            static let instance = TwitterClient(baseURL: kTwitterBaseUrl, consumerKey: kTwitterConsumerKey, consumerSecret: kTwitterConsumerSecret)
        }
        
        return Singleton.instance
    }
    
    func homeTimelineWithParams(params: [String: String]?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation, response) -> Void in
            println(response)
            
            let tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            completion(tweets: tweets, error: nil)
            
        }, failure: { (operation, error) -> Void in
            println("failed to get the current user!")
            completion(tweets: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // fetch request token and redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken) -> Void in
            println("got the request token!")
            
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            
            
        }) { (error) -> Void in
            println("Failed to get the request token!")
            self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken(queryString: url.query), success: { (accessToken) -> Void in
            
            println("got the access token")
            
            self.requestSerializer.saveAccessToken(accessToken)
            
            self.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation, response) -> Void in
                let user = User(dictionary: response as NSDictionary)
                User.currentUser = user
                println("current user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation, error) -> Void in
                println("failed to get the current user!")
                self.loginCompletion?(user: nil, error: error)
            })
            
        }) { (error) -> Void in
            println("failed to get the access token")
            self.loginCompletion?(user: nil, error: error)
        }

    }
}
