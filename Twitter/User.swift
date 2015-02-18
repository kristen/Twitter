//
//  User.swift
//  Twitter
//
//  Created by Kristen on 2/17/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import Foundation

class User: NSObject {
    
    let name: String?
    let screenname: String?
    let profileImageUrl: String?
    let tagline: String?
    let json: JSON

    convenience init(dictionary: NSDictionary) {
        
        let json = JSON(dictionary)
        
        self.init(json: json)
    }
    
    init(json: JSON) {
        self.json = json
        self.name = json["name"].stringValue
        self.screenname = json["screen_name"].stringValue
        self.profileImageUrl = json["profile_image_url"].stringValue
        self.tagline = json["description"].stringValue
        
        super.init()
    }
}
