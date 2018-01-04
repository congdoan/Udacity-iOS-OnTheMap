//
//  UserListViewController.swift
//  On the Map
//
//  Created by Cong Doan on 1/2/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import UIKit

class UserListViewController: TabItemViewController {

    var parentTabBarController: UserTabBarController!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        parentTabBarController = (tabBarController as! UserTabBarController)
        
        print("1. ", Date())
        
        if parentTabBarController.userPins.count == 0 {
            showDataFetchingIndicator()
        }
    }

    override func showDataFetchingIndicator() {
        spinner.startAnimating()
    }
    
    override func hideDataFetchingIndicator() {
        DispatchQueue.main.async {
            // This code will execute each time the fetching of student locations completes.
            // And the first fetch probably finishs even before the View of this controller is loaded.
            // Thus this check is necessary to avoid 'found nil while unwrapping optional' crash.
            if self.spinner != nil {
                self.spinner.stopAnimating()
            }
        }
    }
    
    override func updateUI() {
        DispatchQueue.main.async {
            // With the same reason above this check is necessary to avoid 'found nil while unwrapping optional' crash.
            if self.tableView != nil {
                self.tableView.reloadData()
            }
        }
    }
    
}


// MARK: - UserListViewController: UITableViewDelegate, UITableViewDataSource

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "UserTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        let userPin = parentTabBarController.userPins[indexPath.row]
        cell?.textLabel!.text = userPin.name
        cell?.detailTextLabel?.text = userPin.mediaURL
        cell?.imageView!.image = #imageLiteral(resourceName: "icon_pin")
        cell?.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parentTabBarController.userPins.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkOpenLink(parentTabBarController.userPins[indexPath.row].mediaURL)
    }
    
}
