//
//  MenuViewController.swift
//  Twitter
//
//  Created by Kristen on 2/27/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate : class {
    func didSelectMenuItem(menuViewController: MenuViewController, forNewMainViewController newMainViewController: MainViewController)
}

enum MenuItem: Int {
    case UserProfile = 0, Logout
    
    static let count = 2
}

class MenuViewController: UIViewController {
    
    weak var delegate: MenuViewControllerDelegate?

    @IBOutlet weak var menuTableView: UITableView! {
        didSet {
            menuTableView.dataSource = self
            menuTableView.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        menuTableView.reloadData()
        menuTableView.registerNib(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
    }
    
    func logout() {
        User.currentUser?.logout()
    }
}

extension MenuViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuItem.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case MenuItem.UserProfile.rawValue:
            return tableView.dequeueReusableCellWithIdentifier("ProfileCell") as ProfileCell
        case MenuItem.Logout.rawValue:
            let cell = UITableViewCell()
            
            cell.textLabel?.text = "Logout"
            
            return cell
        default:
            let cell = UITableViewCell()
            
            cell.textLabel?.text = "Missing Cell for indexPath.row = \(indexPath.row)"
            
            return cell
        }
    }
}

extension MenuViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case MenuItem.UserProfile.rawValue:
            let userProfileViewController = UserProfileViewController(nibName: "UserProfileViewController", bundle: nil)
            
            userProfileViewController.setUser(User.currentUser!)
            
            delegate?.didSelectMenuItem(self, forNewMainViewController: userProfileViewController)
        case MenuItem.Logout.rawValue:
            
            let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
            
            delegate?.didSelectMenuItem(self, forNewMainViewController: loginViewController)
            
            logout()
        default:
            break
        }
    }
}