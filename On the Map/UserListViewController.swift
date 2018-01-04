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
        
        if parentTabBarController.userPins.count == 0 {
            showDataFetchingIndicator()
        }
    }

    override func showDataFetchingIndicator() {
        spinner.startAnimating()
    }
    
    override func hideDataFetchingIndicator() {
        DispatchQueue.main.async {
            if self.spinner != nil {
                self.spinner.stopAnimating()
            }
        }
    }
    
    override func updateUI() {
        DispatchQueue.main.async {
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
