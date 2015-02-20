//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Kristen on 2/17/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    private var tweets = [Tweet]()
    @IBOutlet private weak var tweetsTableView: UITableView!
    private var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tweetsTableView.dataSource = self
        
        // UITableViewCell
        tweetsTableView.registerNib(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "TweetCell")
        tweetsTableView.estimatedRowHeight = 95
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        
        // UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchTweets", forControlEvents: UIControlEvents.ValueChanged)
        tweetsTableView.insertSubview(refreshControl, atIndex: 0)
        
        navigationItem.title = "Tweets"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "onLogout")
        
        fetchTweets()
    }

    
    func fetchTweets() {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweetsOptional, error) -> () in
            if let tweets = tweetsOptional {
                self.tweets = tweets
                self.tweetsTableView.reloadData()
                self.refreshControl.endRefreshing()
            } else {
                println("error loading tweets")
            }
        })
    }
    
    func onLogout() {
        User.currentUser?.logout()
    }
}

extension TweetsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweetCell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell
        
        tweetCell.setTweet(tweets[indexPath.row])
        
        return tweetCell
    }
}
