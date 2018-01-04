//
//  UserTabBarController.swift
//  On the Map
//
//  Created by Cong Doan on 1/2/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import UIKit

class UserTabBarController: UITabBarController {

    var userPins = [UserPin]() {
        didSet {
            if let userListVC = childViewControllers[1].childViewControllers.first as? UserListViewController {
                userListVC.hideDataFetchingIndicator()
                userListVC.updateUI()
            }
        }
    }
    
}
