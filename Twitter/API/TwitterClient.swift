//
//  TwitterClient.swift
//  Twitter
//
//  Created by Kristen on 2/15/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    let kTwitterConsumerKey = "g5eGUNtmGb07a0Ozxhbih9FjJ"
    let kTwitterConsumerSecret = "l4jtKchHoF1pTpJzVHh1AaTH0UdhuEc6UKzHov6JHrkKLe4zCN"
    let kTwitterBaseUrl = "https://api.twitter.com"
    
    
    // http://stackoverflow.com/questions/24024549/dispatch-once-singleton-model-in-swift
//    class var sharedInstance: TwitterClient {
//        let kTwitterBaseUrl = "https://api.twiiter.com"
//        let kTwitterConsumerKey = "g5eGUNtmGb07a0Ozxhbih9FjJ"
//        let kTwitterConsumerSecret = "l4jtKchHoF1pTpJzVHh1AaTH0UdhuEc6UKzHov6JHrkKLe4zCN"
//        
//        struct Singleton {
//            static let instance = TwitterClient(baseURL: NSURL(string: kTwitterBaseUrl), consumerKey: kTwitterConsumerKey, consumerSecret: kTwitterConsumerSecret)
//        }
//        
//        return Singleton.instance
//    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init(baseURL: NSURL(string: kTwitterBaseUrl)!, consumerKey: kTwitterConsumerKey, consumerSecret: kTwitterConsumerSecret)

    }
}
