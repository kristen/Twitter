//
//  Tweet.swift
//  Twitter
//
//  Created by Kristen on 2/17/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    let text: String?
    let createdAt: NSDate?
    let user: User?
    
    init(dictionary: NSDictionary) {
        let json = JSON(dictionary)
        
        self.text = json["text"].stringValue
        
        self.user = User(dictionary: dictionary["user"] as NSDictionary)
        
        let createdAtString = json["created_at"].stringValue
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z y"
        // TODO: make lazy var
        self.createdAt = formatter.dateFromString(createdAtString)!
        
        super.init()
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        return array.map { Tweet(dictionary: $0) }
    }
}
