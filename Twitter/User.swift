//
//  User.swift
//  Twitter
//
//  Created by Kristen on 2/17/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import Foundation

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    
    let name: String?
    let screenname: String?
    let profileImageUrl: String?
    let tagline: String?
    let favoritesCount: NSNumber?
    let followersCount: NSNumber?
    let statusesCount: NSNumber?
    let following: Bool?
    let location: String?
    let backgroundImageUrl: String?
    
    let dictionary: NSDictionary

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        let json = JSON(dictionary)
        
        self.name = json["name"].stringValue
        self.screenname = json["screen_name"].stringValue
        self.profileImageUrl = json["profile_image_url"].stringValue
        self.tagline = json["description"].stringValue
        self.favoritesCount = json["favourites_count"].numberValue
        self.followersCount = json["followers_count"].numberValue
        self.statusesCount = json["statuses_count"].numberValue
        self.following = json["following"].boolValue
        self.location = json["location"].stringValue
        self.backgroundImageUrl = json["profile_background_image_url_https"].stringValue
        
        super.init()
    }
    
    class var currentUser: User? {
        get {
            
            if _currentUser == nil {
                if let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData {
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(_currentUser!.dictionary, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
}
