//
//  MentionsViewController.swift
//  Twitter
//
//  Created by Kristen on 2/28/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

class MentionsViewController: TweetsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Mentions"
    }

    override func fetchTweets() {
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        TwitterClient.sharedInstance.mentionsTimelineWithParams(nil, completion: { (tweetsOptional, error) -> () in
            if let tweets = tweetsOptional {
                self.tweets = tweets
                self.tweetsTableView.reloadData()
                self.refreshControl.endRefreshing()
            } else {
                println("error loading mentions")
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }

}
