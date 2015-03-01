//
//  ContainerViewController.swift
//  Twitter
//
//  Created by Kristen on 2/27/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var mainNavigationController: UINavigationController! {
        didSet {
            view.addSubview(mainNavigationController.view)
            addChildViewController(mainNavigationController)
            mainNavigationController.didMoveToParentViewController(self)
            mainNavigationController.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "onPan:"))
        }
    }
    var mainViewController: MainViewController!
    
    var menuOpen: Bool = false {
        didSet {
            shouldShowShadow(menuOpen)
            mainViewController.view.userInteractionEnabled = !menuOpen
            mainViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .Plain, target: self, action: "toggleMenu")
        }
    }
    
    var menuNavigationViewController: UINavigationController?
    
    let mainPanelExpandedOffset: CGFloat = 100

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mainViewController = TweetsViewController(nibName: "TweetsViewController", bundle: nil)
        
        mainNavigationController = UINavigationController(rootViewController: mainViewController)
        mainViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .Plain, target: self, action: "toggleMenu")
    }

    func toggleMenu() {
        println("toggle menu")

        if !menuOpen {
            addMenuViewController()
        }
        
        animateMenu(shouldExpand: !menuOpen)
    }
    
    func addMenuViewController() {
        if menuNavigationViewController == nil {
            let menuViewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
            menuViewController.delegate = self
            menuNavigationViewController = UINavigationController(rootViewController: menuViewController)
            view.insertSubview(menuNavigationViewController!.view, atIndex: 0)
            addChildViewController(menuNavigationViewController!)
            menuNavigationViewController!.didMoveToParentViewController(self)
        }
    }
    
    func animateMenu(#shouldExpand: Bool) {
        if shouldExpand {
            menuOpen = true
            
            animateTweetPanelXPosition(targetPosition: CGRectGetWidth(mainNavigationController.view.frame) - mainPanelExpandedOffset)
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
            self.mainNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    func shouldShowShadow(showShadow: Bool) {
        if showShadow {
            mainNavigationController.view.layer.shadowOpacity = 0.6
        } else {
            mainNavigationController.view.layer.shadowOpacity = 0.0
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

extension ContainerViewController : MenuViewControllerDelegate {
    func didSelectMenuItem(menuViewController: MenuViewController, forNewMainViewController newMainViewController: MainViewController) {
        

            // remove last mainViewController
//            self.mainNavigationController!.view.removeFromSuperview()
            
            // set new one
//            self.mainViewController = mainViewController
//            mainNavigationController = UINavigationController(rootViewController: newMainViewController)
            
            // bad, .view = .view is crashing UIViewControllerHierarchyInconsistency
//            self.mainViewController = newMainViewController
//            self.mainNavigationController!.view = newMainViewController.view
            
            
            
            // works

            newMainViewController.view.frame = self.mainViewController.view.frame
            self.mainViewController.view.addSubview(newMainViewController.view)


        
        animateMenu(shouldExpand: false)
    }
}
