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
    
    var menuOpen: Bool = false {
        didSet {
            shouldShowShadow(menuOpen)
        }
    }
    
    var menuNavigationViewController: UINavigationController?
    
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
            if menuNavigationViewController == nil {
                menuNavigationViewController = UINavigationController(rootViewController: MenuViewController(nibName: "MenuViewController", bundle: nil))
//                menuViewController!.view.frame = view.frame
                view.insertSubview(menuNavigationViewController!.view, atIndex: 0)
                addChildViewController(menuNavigationViewController!)
                menuNavigationViewController!.didMoveToParentViewController(self)
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
                
                self.menuNavigationViewController!.view.removeFromSuperview()
                self.menuNavigationViewController = nil
            })
        }
    }
    
    func animateTweetPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.tweetsNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    func shouldShowShadow(showShadow: Bool) {
        if showShadow {
            tweetsNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            tweetsNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
}
