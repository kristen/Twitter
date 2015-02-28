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
            tweetsViewController.view.userInteractionEnabled = !menuOpen
        }
    }
    
    var menuNavigationViewController: UINavigationController?
    
    let tweetsPanelExpandedOffset: CGFloat = 100

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tweetsViewController = TweetsViewController(nibName: "TweetsViewController", bundle: nil)
        
        tweetsNavigationController = UINavigationController(rootViewController: tweetsViewController)

        tweetsNavigationController.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "onPan:"))
    }
    
}

extension ContainerViewController : TweetsViewControllerDelegate {
    func toggleMenu() {
        println("toggle menu")

        if !menuOpen {
            addMenuViewController()
        }
        
        animateMenu(shouldExpand: !menuOpen)
    }
    
    func addMenuViewController() {
        if menuNavigationViewController == nil {
            menuNavigationViewController = UINavigationController(rootViewController: MenuViewController(nibName: "MenuViewController", bundle: nil))
            view.insertSubview(menuNavigationViewController!.view, atIndex: 0)
            addChildViewController(menuNavigationViewController!)
            menuNavigationViewController!.didMoveToParentViewController(self)
        }
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
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.tweetsNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    func shouldShowShadow(showShadow: Bool) {
        if showShadow {
            tweetsNavigationController.view.layer.shadowOpacity = 0.6
        } else {
            tweetsNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
}

extension ContainerViewController : UIGestureRecognizerDelegate {
    func onPan(guesture: UIPanGestureRecognizer) {
        let guestureDragedFromLeftToRight = guesture.velocityInView(view).x > 0
        
        switch guesture.state {
        case .Began:
            if !menuOpen && guestureDragedFromLeftToRight {
                addMenuViewController()
                shouldShowShadow(true)
            }
        case .Changed:
            if !menuOpen && guestureDragedFromLeftToRight || menuOpen && !guestureDragedFromLeftToRight {
                guesture.view!.center.x += guesture.translationInView(view).x
                guesture.setTranslation(CGPointZero, inView: view)
            }
        case .Ended:
            if menuNavigationViewController != nil {
                let hasMovedGreaterThanHalfWay = guesture.view!.center.x > view.bounds.size.width
                animateMenu(shouldExpand: hasMovedGreaterThanHalfWay)
            }
        case .Failed: fallthrough
        case .Cancelled: fallthrough
        case .Possible: break
        }
    }
}
