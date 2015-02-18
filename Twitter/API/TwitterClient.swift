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
    
    
    // http://stackoverflow.com/questions/24024549/dispatch-once-singleton-model-in-swift
    class var sharedInstance: TwitterClient {

        struct Singleton {
            static let instance = TwitterClient(baseURL: kTwitterBaseUrl, consumerKey: kTwitterConsumerKey, consumerSecret: kTwitterConsumerSecret)
        }
        
        return Singleton.instance
    }
}
