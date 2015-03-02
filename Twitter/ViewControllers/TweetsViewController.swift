//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Kristen on 2/17/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

class TweetsViewController: MainViewController {
    internal var tweets = [Tweet]()
    @IBOutlet internal weak var tweetsTableView: UITableView! {
        didSet {
            tweetsTableView.dataSource = self
            tweetsTableView.delegate = self
        }
    }
    internal var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // UITableViewCell
        tweetsTableView.registerNib(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "TweetCell")
        tweetsTableView.estimatedRowHeight = 105
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        
        // UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchTweets", forControlEvents: UIControlEvents.ValueChanged)
        tweetsTableView.insertSubview(refreshControl, atIndex: 0)
        
        navigationItem.title = "Home"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "composeNewTweet")
        
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
    
    func composeNewTweet() {
        composeNewTweet(nil)
    }
    
    func composeNewTweet(replyTweet: Tweet?) {
        let composeTweetViewController = ComposeTweetViewController(nibName: "ComposeTweetViewController", bundle: nil)
        composeTweetViewController.delegate = self
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
    }
}

extension TweetsViewController: TweetCellDelegate {
    func tweetCell(tweetCell: TweetCell, didReplyToTweet replyTweet: Tweet) {
        composeNewTweet(replyTweet)
    }
    
    func tweetCell(tweetCell: TweetCell, showProfileForUser user: User?) {
        println("showed user profile page")
        
        let userProfileViewController = UserProfileViewController(nibName: "UserProfileViewController", bundle: nil)
        userProfileViewController.setUser(user!)
        navigationController?.pushViewController(userProfileViewController, animated: true)
    }
}

extension TweetsViewController: ComposeTweetViewControllerDelegate {
    func composeTweetViewController(composeTweetViewController: ComposeTweetViewController, didTweet tweet: Tweet) {
        self.tweets.insert(tweet, atIndex: 0)
        tweetsTableView.reloadData()
    }
}