//
//  UserListViewController.swift
//  On the Map
//
//  Created by Cong Doan on 1/2/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import UIKit

class UserListViewController: TabItemViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var userPins: [UserPin]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        userPins = (tabBarController as! UserTabBarController).userPins
        print(userPins.count)
    }

}


// MARK: - UserListViewController: UITableViewDelegate, UITableViewDataSource

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "UserTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        let userPin = userPins[indexPath.row]
        cell?.textLabel!.text = userPin.name
        cell?.detailTextLabel?.text = userPin.mediaURL
        cell?.imageView!.image = #imageLiteral(resourceName: "icon_pin")
        cell?.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPins.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkOpenLink(userPins[indexPath.row].mediaURL)
    }
    
}
