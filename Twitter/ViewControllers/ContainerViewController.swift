//
//  ContainerViewController.swift
//  Twitter
//
//  Created by Kristen on 2/27/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var tweetsNavigationController: UINavigationController!
    var tweetsViewController: TweetsViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tweetsViewController = TweetsViewController(nibName: "TweetsViewController", bundle: nil)
        tweetsViewController.delegate = self
        
        tweetsNavigationController = UINavigationController(rootViewController: tweetsViewController)
        view.addSubview(tweetsNavigationController.view)
        addChildViewController(tweetsNavigationController)
        
        tweetsNavigationController.didMoveToParentViewController(self)
        
    }
    
}

extension ContainerViewController : TweetsViewControllerDelegate {
    func toggleMenu() {
        println("toggle menu")
    }
}
