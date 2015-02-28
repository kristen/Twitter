//
//  ContainerViewController.swift
//  Twitter
//
//  Created by Kristen on 2/27/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var tweetsNavigationController: UINavigationController! {
        didSet {
            view.addSubview(tweetsNavigationController.view)
            addChildViewController(tweetsNavigationController)
            tweetsNavigationController.didMoveToParentViewController(self)
        }
    }
    var tweetsViewController: TweetsViewController! {
        didSet {
            tweetsViewController.delegate = self
        }
    }
    
    var menuOpen = false
    
    var menuViewController: MenuViewController?
    
    let tweetsPanelExpandedOffset: CGFloat = 60

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tweetsViewController = TweetsViewController(nibName: "TweetsViewController", bundle: nil)
        
        tweetsNavigationController = UINavigationController(rootViewController: tweetsViewController)
        
    }
    
}

extension ContainerViewController : TweetsViewControllerDelegate {
    func toggleMenu() {
        println("toggle menu")

        if !menuOpen {
            if menuViewController == nil {
                menuViewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
                view.insertSubview(menuViewController!.view, atIndex: 0)
                addChildViewController(menuViewController!)
                menuViewController!.didMoveToParentViewController(self)
            }
        }
        
        animateMenu(shouldExpand: !menuOpen)
    }
    
    func animateMenu(#shouldExpand: Bool) {
        if shouldExpand {
            menuOpen = true
            
            animateTweetPanelXPosition(targetPosition: CGRectGetWidth(tweetsNavigationController.view.frame) - tweetsPanelExpandedOffset)
        } else {
            animateTweetPanelXPosition(targetPosition: 0, completion: { (finished) -> Void in
                self.menuOpen = false
                
                self.menuViewController!.view.removeFromSuperview()
                self.menuViewController = nil
            })
        }
    }
    
    func animateTweetPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.tweetsNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
}
