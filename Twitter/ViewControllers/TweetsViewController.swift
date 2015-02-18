//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Kristen on 2/17/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    var tweets: [Tweet]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweetsOptional, error) -> () in
            if let tweets = tweetsOptional {
                self.tweets = tweets
            } else {
                println("error loading tweets")
                self.tweets = []
            }
        })
    }

    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
