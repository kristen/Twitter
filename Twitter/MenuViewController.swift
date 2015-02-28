//
//  MenuViewController.swift
//  Twitter
//
//  Created by Kristen on 2/27/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var menuTableView: UITableView! {
        didSet {
            menuTableView.dataSource = self
            menuTableView.delegate = self
        }
    }
    
    var menuItems : [MenuItem] = [MenuItem(label: "Logout", onTouch: User.currentUser!.logout)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        menuTableView.reloadData()
    }
    

    func onLogout() {
        User.currentUser?.logout()
    }
}

extension MenuViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = menuItems[indexPath.row].label
        
        return cell
    }
}

extension MenuViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        menuItems[indexPath.row].onTouch()
    }
}

class MenuItem: NSObject {
    var label: String
    var onTouch: () -> Void
    
    init(label: String, onTouch: () -> Void) {
        self.label = label
        self.onTouch = onTouch
    }
}