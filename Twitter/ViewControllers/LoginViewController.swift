//
//  LoginViewController.swift
//  Twitter
//
//  Created by Kristen on 2/15/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

class LoginViewController: MainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = "Login"
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        
        TwitterClient.sharedInstance.loginWithCompletion { (user, error) -> () in
            if user != nil {
                
                self.presentViewController(ContainerViewController(), animated: true, completion: nil)
                
            } else {
                // handle login error
                println("error logging in user")
            }
        }
    }
}
