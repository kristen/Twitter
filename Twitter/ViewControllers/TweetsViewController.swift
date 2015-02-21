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
        tweetsTableView.delegate = self
        
        // UITableViewCell
        tweetsTableView.registerNib(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "TweetCell")
        tweetsTableView.estimatedRowHeight = 105
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        
        // UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchTweets", forControlEvents: UIControlEvents.ValueChanged)
        tweetsTableView.insertSubview(refreshControl, atIndex: 0)
        
        navigationItem.title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "onLogout")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .Plain, target: self, action: "composeNewTweet")
        
        fetchTweets()
    }

    
    func fetchTweets() {
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweetsOptional, error) -> () in
            if let tweets = tweetsOptional {
                self.tweets = tweets
                self.tweetsTableView.reloadData()
                self.refreshControl.endRefreshing()
            } else {
                println("error loading tweets")
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    func onLogout() {
        User.currentUser?.logout()
    }
    
    func composeNewTweet() {
        composeNewTweet(nil)
    }
    
    func composeNewTweet(replyTweet: Tweet?) {
        let composeTweetViewController = ComposeTweetViewController(nibName: "ComposeTweetViewController", bundle: nil)
        
        composeTweetViewController.setReplyTweet(replyTweet)
        
        navigationController?.presentViewController(UINavigationController(rootViewController: composeTweetViewController), animated: true, completion: nil)
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
        tweetCell.delegate = self
        
        return tweetCell
    }
}

extension TweetsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailViewController = TweetDetailViewController(nibName: "TweetDetailViewController", bundle: nil)
        detailViewController.setTweet(tweets[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)

//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        cell?.selectionStyle = .None
    }
}

extension TweetsViewController: TweetCellDelegate {
    func tweetCell(tweetCell: TweetCell, didReplyToTweet replyTweet: Tweet) {
        composeNewTweet(replyTweet)
    }
}
